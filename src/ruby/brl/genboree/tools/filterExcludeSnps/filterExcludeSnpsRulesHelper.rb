require 'brl/genboree/tools/workbenchRulesHelper'
require 'brl/genboree/tools/workbenchFormHelper'
require 'brl/genboree/rest/helpers/trackApiUriHelper'
require 'brl/genboree/rest/helpers/databaseApiUriHelper'
require 'uri'
require 'brl/genboree/genboreeUtil'
require 'brl/genboree/rest/apiCaller'
include BRL::Genboree::REST

module BRL ; module Genboree ; module Tools
  class FilterExcludeSnpsRulesHelper < WorkbenchRulesHelper

    TOOL_ID = 'filterExcludeSnps'

    # TODO: replace this!
    def rulesSatisfied?(wbJobEntity, sectionsToSatisfy=[ :inputs, :outputs, :context, :settings ], toolIdStr=@toolIdStr)
      # Apply basic rules from the rules file (counts, basic types, other simple things)
      rulesSatisfied = super(wbJobEntity, sectionsToSatisfy, toolIdStr)
      return rulesSatisfied
    end
  end
end ; end; end # module BRL ; module Genboree ; module Tools