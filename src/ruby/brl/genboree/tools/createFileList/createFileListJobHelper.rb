require 'json'
require 'brl/util/util'
require 'brl/genboree/genboreeUtil'
require 'uri'
require 'brl/genboree/rest/helpers/databaseApiUriHelper'
require 'brl/genboree/rest/helpers/sampleSetApiUriHelper'
require "brl/genboree/rest/helpers/fileApiUriHelper"
require "brl/genboree/tools/workbenchJobHelper"
require 'brl/genboree/rest/wrapperApiCaller'
include BRL::Genboree::REST

module BRL ; module Genboree ; module Tools
  class CreateFileListJobHelper < WorkbenchJobHelper

    TOOL_ID = 'createFileList'

    # Instance vars that should be overridden to launch the job
    def initialize(toolIdStr, genbConf=nil, dbu=nil, *args)
      super(toolIdStr, genbConf, dbu, args)
    end

    def runInProcess()
      success = true
      inputs = @workbenchJobObj.inputs
      fileEntityListName = CGI.escape(@workbenchJobObj.settings['fileEntityListName'])
      output = @workbenchJobObj.outputs[0]
      uri = URI.parse(output)
      host = uri.host
      rsrcPath = uri.path
      urlList = []
      inputs.each { |input|
        urlList << {"url" => input}
      }
      apiCaller = WrapperApiCaller.new(host, "#{rsrcPath}/files/entityList/#{fileEntityListName}?", @userId)
      # Making internal API call
      apiCaller.initInternalRequest(@rackEnv, @genbConf.machineNameAlias) if(@rackEnv)
      payload = {"data" => urlList}
      resp = apiCaller.put(payload.to_json)
      if(!apiCaller.succeeded?)
        success = false
        @workbenchJobObj.context['wbErrorMsg'] = JSON.parse(apiCaller.respBody)['status']['msg']
      else
        @workbenchJobObj.context['response'] = JSON.parse(apiCaller.respBody)['status']['msg']
      end
      return success
    end

  end
end ; end ; end # module BRL ; module Genboree ; module Tools
