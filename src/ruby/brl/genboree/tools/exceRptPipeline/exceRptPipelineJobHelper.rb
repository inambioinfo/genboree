require 'uri'
require 'json'
require 'brl/util/util'
require 'brl/db/dbrc'
require 'brl/genboree/genboreeUtil'
require 'brl/genboree/rest/helpers/databaseApiUriHelper'
require 'brl/genboree/rest/helpers/groupApiUriHelper'
require 'brl/genboree/tools/workbenchJobHelper'
require 'brl/genboree/rest/helpers/fileApiUriHelper'

module BRL ; module Genboree ; module Tools
  class ExceRptPipelineJobHelper < WorkbenchJobHelper

    TOOL_ID = 'exceRptPipeline'

    # Instance vars that should be overridden to launch the job
    def initialize(toolIdStr, genbConf=nil, dbu=nil, *args)
      super(toolIdStr, genbConf, dbu, args)
      self.class.commandName = "exceRptPipelineWrapper.rb"
    end

    # This is where the command is defined
    #
    # WARNING: Be careful when building a command to be executed.
    # Any command line option values must be properly escaped.
    #
    # For example: someone submitted a var @settings['foo'] = ';rm -dfr /'
    # and then you build a command without escaping
    # "myCommand.rb -n #{foo}"  =>  myCommand.rb -n ;rm -dfr /
    # The correct way to do this is using CGI.escape()
    # "myCommand.rb -n #{CGI.escape(foo)}"  =>  myCommand.rb -n %3Brm%20-dfr%20%2F
    #
    # [+returns+] string: the command
    def buildCmd(useCluster=true)
      cmd = ''
      commandName = self.class.commandName
      $stderr.puts "commandName: #{commandName.inspect}"
      raise NoMethodError.new("FATAL INTERNAL ERROR: Must have a commandName class instance variable in child class or buildCmd() should be overridden by child class if parent/default executionCallback is used.") if(commandName.nil?)
      if(useCluster)
        cmd = "#{commandName} -j ./#{@genbConf.gbJobJSONFile} "
      else
        msg = "ERROR: The #{TOOL_NAME} cluster analysis tool requires a cluster to run."
        $stderr.puts msg
        @workbenchJobObj = workbenchJobObj
        # Add errors to the context so they can be display to user
        @workbenchJobObj.context['wbErrorName'] = :'Internal Server Error'
        @workbenchJobObj.context['wbErrorMsg'] = msg
      end
      return cmd
    end

    # INTERFACE METHOD. Returns an Array of any additional exports that need to appear in the
    # cluster .pbs file. They appear just before the call to "commandWrapper.rb". i.e. AFTER
    # the appropriate env location variables have been set.
    # - By default, empty; no extra exports
    def exports()
      return [
        "export CLASSPATH=$SITE_JARS/GDASServlet.jar:$SITE_JARS/servlet-api.jar:$SITE_JARS/mysql-connector-java.jar:$SITE_JARS/mail.jar"
      ]
    end

    # INTERFACE METHOD. Returns an Array of commands that should be run very early in
    # the tool pipeline. These will be executed directly from the pbs file.
    # - They will run after the scratch dir is made and the job file sync'd over.
    # - Therefore suitable for global module load/swap commands that may set/change
    #   key env-variables (which will then need fixing)
    #
    # These are added to Job#preCommands at/near the top.
    #
    # Example, say you need to swap in a new jdk and thus want the $SITE_JARS updated
    # correctly depending on the environment. Return this:
    #
    #   [
    #     "module swap jdk/1.6"
    #   ]
    def preCmds()
      currentModule = ""  
      if(@workbenchJobObj.settings["exceRptGen"] == "fourthGen")
        currentModule = "exceRptPipeline/4_prod"
      else
        currentModule = "exceRptPipeline/3_prod_alt"
      end
      return ["module load #{currentModule}"]
    end

    def postCmds()
      return ["fileApiTransfer.rb #{@userId} ./jobFile.json #{CGI.escape(@jobFileCopyUriPaths)}"]
    end

    # Casts certain args to the tool to integer
    # [+workbenchJobObj+]
    # [+returns+] workbenchJobObj
    def cleanJobObj(workbenchJobObj)
      output = workbenchJobObj.outputs[0]
      workbenchJobObj.outputs[0] = @dbApiHelper.extractPureUri(output)
      workbenchJobObj.settings['genomeVersion'] = @dbApiHelper.dbVersion(output, @hostAuthMap).downcase
      group = @grpApiHelper.extractName(output)
      db = @dbApiHelper.extractName(output)
      analysisName = workbenchJobObj.settings['analysisName']
      uri = URI.parse(output)
      # Get the tool version of exceRptPipeline from toolConf
      toolVersion = @toolConf.getSetting('info', 'version')
      if(workbenchJobObj.settings["exceRptGen"] == "thirdGen")
        toolVersion = "3.3.0"
      end
      workbenchJobObj.settings['toolVersion'] = toolVersion
      # The option of "None Selected" from Workbench for remote storage is not a real option.
      workbenchJobObj.settings['remoteStorageArea'] = nil if(workbenchJobObj.settings['remoteStorageArea'] == "None Selected")
      # Grab remote storage area
      remoteStorageArea = workbenchJobObj.settings['remoteStorageArea']
      # Set path for jobFile.json on the basis of whether we have a remote storage area being used or not
      unless(remoteStorageArea)
        @jobFileCopyUriPaths << "http://#{uri.host}/REST/v1/grp/#{CGI.escape(group)}/db/#{CGI.escape(db)}/file/exceRptPipeline_v#{toolVersion}/#{CGI.escape(analysisName)}/jobFile.json/data?"
      else
        @jobFileCopyUriPaths << "http://#{uri.host}/REST/v1/grp/#{CGI.escape(group)}/db/#{CGI.escape(db)}/file/#{remoteStorageArea}/exceRptPipeline_v#{toolVersion}/#{CGI.escape(analysisName)}/jobFile.json/data?"
      end
      # We can clean up some variables right now from settings that are NEVER used after the UI stage
      # Delete list of possible data repos
      workbenchJobObj.settings.delete('anticipatedDataRepos')
      # Delete list of possible grant numbers associated with user
      workbenchJobObj.settings.delete('grantNumbers')
      # Delete misc. settings associated with endogenous library ordering
      workbenchJobObj.settings.delete('spinnerField_circRNAOrder')
      workbenchJobObj.settings.delete('spinnerField_gencodeOrder')
      workbenchJobObj.settings.delete('spinnerField_miRNAOrder')
      workbenchJobObj.settings.delete('spinnerField_piRNAOrder')
      workbenchJobObj.settings.delete('spinnerField_tRNAOrder')
      # Delete misc. settings associated with calibrator, depending on which options the user has chosen
      workbenchJobObj.settings.delete('subdirs')
      workbenchJobObj.settings.delete('wbContext')
      # Delete misc. advanced settings
      workbenchJobObj.settings.delete('remoteStorageAreas')
      return workbenchJobObj
    end
  end
end ; end ; end # module BRL ; module Genboree ; module Tools
