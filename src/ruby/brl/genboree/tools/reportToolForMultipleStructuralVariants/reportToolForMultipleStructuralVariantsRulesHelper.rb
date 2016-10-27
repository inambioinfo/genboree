require 'brl/genboree/tools/workbenchRulesHelper'
require 'brl/genboree/tools/workbenchFormHelper'
require 'brl/genboree/rest/helpers/trackApiUriHelper'
require 'brl/genboree/rest/helpers/databaseApiUriHelper'
require 'uri'
require 'brl/genboree/genboreeUtil'
require 'brl/genboree/rest/apiCaller'
include BRL::Genboree::REST

module BRL ; module Genboree ; module Tools
  class ReportToolForMultipleStructuralVariantsRulesHelper < WorkbenchRulesHelper

    TOOL_ID = 'reportToolForMultipleStructuralVariants'

    def rulesSatisfied?(wbJobEntity, sectionsToSatisfy=[ :inputs, :outputs, :context, :settings ], toolIdStr=@toolIdStr)
      # Apply basic rules from the rules file (counts, basic types, other simple things)
      rulesSatisfied = super(wbJobEntity, sectionsToSatisfy, toolIdStr)

      if(rulesSatisfied)
        @dbu = BRL::Genboree::DBUtil.new("#{@genbConf.dbrcKey}", nil, nil)
        # Must pass the rest of the checks as well
        rulesSatisfied = false
        folderCount = 0
        outputs = wbJobEntity.outputs
        inputs = wbJobEntity.inputs
        genbConf = BRL::Genboree::GenboreeConfig.load()
        dbrcFile = File.expand_path(ENV['DBRC_FILE'])
        user = @superuserApiDbrc.user
        pass = @superuserApiDbrc.password
        # ------------------------------------------------------------------
        # Check Inputs/Outputs
        # ------------------------------------------------------------------
        userId = wbJobEntity.context['userId']
        # Check 2: Need to make sure all dragged folders come from the 'Structural Variant Detection' tool
        validFolder = true
        maxInsertSize = []
        error = ''
        inputs.each { |input|
          if(input !~ BRL::Genboree::REST::Helpers::TrackApiUriHelper::NAME_EXTRACTOR_REGEXP)
            # First read json file
            folderCount += 1
            input.gsub!("/files/", "/file/")
            uri = URI.parse(input)
            host = uri.host
            path = "#{uri.path.chomp("?")}/jobFile.json/data?"
            $stderr.puts "DEBUG: make args for creating ApiCaller using current input: #{input.inspect}\n  #{host.inspect}\n  #{path.inspect}"
            idxFileApiCaller = ApiCaller.new(host, path, @hostAuthMap)
            $stderr.puts "DEBUG: about to set up internal api call for index file"
            idxFileApiCaller.initInternalRequest(@rackEnv, genbConf.machineNameAlias) if(@rackEnv)
            $stderr.puts "DEBUG: doing index file get..." ; t1 = Time.now
            idxFileApiCaller.get()
            idxFileContent = idxFileApiCaller.respBody.dup
            $stderr.puts "DEBUG: index get returned (#{Time.now - t1}):\n#{idxFileContent}"
            if(!idxFileApiCaller.succeeded?) # Failed
              validFolder = false
              error = "BAD INPUT FOLDER: Could not find valid jobFile.json file, indicating the input folder does not correspond to the output of a previously run job. All input folders MUST come from the 'Basic Set Operations On Structural Variants' tool."
              break
            else
              $stderr.puts "DEBUG: about to parse this json:\n####\n#{idxFileContent}\n####"
              retVal = JSON.parse(idxFileContent)
              if(retVal['context']['toolIdStr'] != 'basicSetOperationsOnStructuralVariants' and retVal['context']['toolIdStr'] != 'structuralVariantDetection')
                validFolder = false
                error = "BAD INPUT FOLDER: All input folders MUST come from either the 'Basic Set Operations On Structural Variants' tool or 'Structural Variant Detection' tool. You appear to have supplied the results folder for some other tool."
                break
              end
              # Also read the summary file (which has 'Maximum Insert Size')
              # We are doing this here to avoid polluting the UI
              wbJobEntity.settings['sourceTool'] = retVal['context']['toolIdStr']
              path = "#{uri.path.chomp("?")}/summary_#{CGI.escape(retVal['settings']['analysisName'])}.txt/data?"
              summaryFileApiCaller = ApiCaller.new(host, path, @hostAuthMap)
              $stderr.puts "DEBUG: about to set up internal api call for summary file"
              summaryFileApiCaller.initInternalRequest(@rackEnv, genbConf.machineNameAlias) if(@rackEnv)
              $stderr.puts "DEBUG: doing summary file get..."
              summaryFileApiCaller.get()
              summaryFileContent = summaryFileApiCaller.respBody.dup
              $stderr.puts "DEBUG: summary get returned (#{Time.now - t1}):\n#{summaryFileContent}"
              if(!summaryFileApiCaller.succeeded?) # Failed
                validFolder = false
                error = "MISSING REQUIRED RESULTS FILE: Could not read file: summary_#{CGI.escape(retVal['settings']['analysisName'])}.txt from the input folder."
                break
              else
                retVal = summaryFileContent
                buffIO = StringIO.new(retVal)
                buffIO.each_line { |line|
                  line.strip!
                  next if(line.nil? or line.empty? or line =~ /^\s*$/ or line =~ /^#/)
                  avps = line.split(/\t/)
                  maxInsertSize.push(avps[1].to_i) if(avps[0] == 'Maximum Insert Size')
                }
              end
            end
            wbJobEntity.settings['maxInsertSize'] = maxInsertSize.max()
          end
        }
        unless(validFolder)
          wbJobEntity.context['wbErrorMsg'] = error
        else
          # Check 3: Make sure all tracks (if there) are non high density
          highDensity = false
          inputs.each{ |input|
            if(input =~ BRL::Genboree::REST::Helpers::TrackApiUriHelper::NAME_EXTRACTOR_REGEXP)
              if(@trkApiHelper.isHdhv?(input, @hostAuthMap))
                highDensity = true
                break
              end
            end
          }
          if(highDensity)
            wbJobEntity.context['wbErrorMsg'] = "All Genomic Feature Track(s) MUST be non high density. "
          else
            # Check4: The target db must be either 'hg18' or 'hg19'
            dbVersion = @dbApiHelper.dbVersion(outputs[0], @hostAuthMap)
            if(dbVersion != 'hg18' and dbVersion != 'hg19')
              wbJobEntity.context['wbErrorMsg'] = "The target database MUST be either 'hg18' or 'hg19'"
            else
              rulesSatisfied = true
            end
          end
        end
        # ------------------------------------------------------------------
        # CHECK SETTINGS
        # ------------------------------------------------------------------
        if(sectionsToSatisfy.include?(:settings))
          # Check :settings together with info from :outputs :
          unless( sectionsToSatisfy.include?(:outputs) and  sectionsToSatisfy.include?(:inputs) )
            raise ArgumentError, "Cannot validate just :settings for this tool without info provided in both :inputs and :outputs."
          end

          rulesSatisfied = false

          # Check 1: Does the job dir already exist?
          rulesSatisfied = false
          # Check 1: The dir for sample set name should not exist
          output = @dbApiHelper.extractPureUri(outputs[0])
          uri = URI.parse(output)
          host = uri.host
          rcscUri = uri.path
          rcscUri = rcscUri.chomp("?")
          rcscUri << "/file/#{CGI.escape("Structural Variation")}/Reports/#{CGI.escape(wbJobEntity.settings['analysisName'])}/jobFile.json?"
          apiCaller = ApiCaller.new(host, rcscUri, @hostAuthMap)
          apiCaller.initInternalRequest(@rackEnv, genbConf.machineNameAlias) if(@rackEnv)
          apiCaller.get()
          if(apiCaller.succeeded?) # Failed: job dir already exists
            wbJobEntity.context['wbErrorMsg'] = "A job with the analysis name: #{wbJobEntity.settings['analysisName'].inspect} has already been launched before. Please select a different analysis name."
          else
            # Check 2: radius should be a positive integer
            radius = wbJobEntity.settings['radius']
            if(radius.nil? or radius.empty? or radius !~ /^\d+$/ or radius.to_i < 0)
              wbJobEntity.context['wbErrorMsg'] = "Radius should be a positive integer (greater than or equal to 0)."
            else
              # Check 3: If there is only one dragged input folder, 'tgpBreakpoints' must be check
              tgpBp = wbJobEntity.settings['tgpBreakpoints']
              if(!tgpBp and folderCount == 1)
                wbJobEntity.context['wbErrorMsg'] = "You must select 'TGP Breakpoints' if you have dragged only one input folder. "
              else
                rulesSatisfied = true
              end
            end
          end
        end
      end
        # ------------------------------------------------------------------
        # CHECK SETTINGS
        # ------------------------------------------------------------------

      # Clean up helpers, which cache many things
      @trkApiHelper.clear() if(!@trkApiHelper.nil?)
      @dbApiHelper.clear() if(!@dbApiHelper.nil?)

      return rulesSatisfied
    end

    # It's a good idea to catch any potential errors now instead of relying on the job to do validation because,
    # the job may get queued and the user wouldn't be notified  for an unnecessarily long time that they have something minor wrong with their inputs.
    #
    # [+returns+] boolean
    def warningsExist?(wbJobEntity)
      warningsExist = true
      if(wbJobEntity.context['warningsConfirmed'])
        # The user has confirmed the warnings and wants to proceed
        warningsExist = false
      else # Look for warnings
        # no warnings for now
        warningsExist = false
      end

      # Clean up helpers, which cache many things
      @trkApiHelper.clear() if(!@trkApiHelper.nil?)
      @dbApiHelper.clear() if(!@dbApiHelper.nil?)

      return warningsExist
    end
  end
end ; end; end # module BRL ; module Genboree ; module Tools
