require 'json'
require 'brl/util/util'
require 'brl/genboree/genboreeUtil'
require 'brl/genboree/dbUtil'
require 'uri'
require 'brl/genboree/rest/helpers/databaseApiUriHelper'
require "brl/genboree/rest/helpers/sampleApiUriHelper"
require 'brl/genboree/abstract/resources/user'
require "brl/genboree/tools/workbenchJobHelper"
require 'brl/genboree/rest/apiCaller'
include BRL::Genboree::REST

module BRL ; module Genboree ; module Tools
  class DeleteSamplesJobHelper < WorkbenchJobHelper
    TOOL_LABEL = 'Delete Samples'
    TOOL_ID = 'deleteSamples'
    TOOL_TYPE = 'Utility'
    # Instance vars that should be overridden to launch the job
    def initialize(toolIdStr, genbConf=nil, dbu=nil, *args)
      super(toolIdStr, genbConf, dbu, args)
    end

    def runInProcess()
      success = true
      inputs = @workbenchJobObj.inputs
      apiDbrc = @superuserApiDbrc
      @killList = []
      problemList = []
      nodeCount = 0
      inputs.each { |sample|
        uri = URI.parse(sample)
        apiCaller = ApiCaller.new(uri.host, uri.path, @hostAuthMap)
        # Making internal API call
        apiCaller.initInternalRequest(@rackEnv, @genbConf.machineNameAlias) if(@rackEnv)
        resp = apiCaller.delete()
        if(apiCaller.succeeded?)
          @killList.push(sample)
        else
          problemList.push(@sampleApiHelper.extractName(sample))
        end
        nodeCount += 1
      }
      if(!problemList.empty?)
        success = false
        @workbenchJobObj.context['wbErrorMsg'] = "The following samples could not be deleted: #{problemList.join(",")}."
      end
      return success
    end

    # [+msgType+]   Symbol: Should be one of :Accepted, :Rejected :Warnings or :Failure
    # [+returns+]   String; Html text
    def getMessage(msgType, wbJobEntity)
      # A String with technical details about the error. Not for users. Backtraces for example. This will just end up in the stderr log.
      # This one may be optional depending on the error (maybe it was a user error or the nature of an input or something) and whether the info is already in the stderr log.
      if(!wbJobEntity.context['wbErrorDetails'].nil?)
        $stderr.puts wbJobEntity.context['wbErrorDetails']
      end
      # Try to render the appropriate job message into HTML depending on message type
      # (:Accepted, :Rejected, :Failure, :Warnings)
      $stderr.puts "msgType: #{msgType.inspect}"
      uiType = nil
      if(msgType == :Warnings)
        uiType = "jobWarnings"
      elsif(msgType == :Rejected)
        uiType = "jobRejected"
      else
        uiType = "jobDeletion"
      end
      toolIdStr = wbJobEntity.context['toolIdStr']
      wbJobEntity.context['resourceType'] = 'samples'
      wbJobEntity.context['killList'] = @killList
      # Add genbConf and toolIdStr to the evaluate() context so they are available
      # as @genbConf and @toolIdStr in the rhtml
      respHtml = renderDialogContent(toolIdStr, uiType, wbJobEntity.getEvalContext(:genbConf => @genbConf, :toolIdStr => toolIdStr))
      return respHtml
    end

  end
end ; end ; end # module BRL ; module Genboree ; module Tools