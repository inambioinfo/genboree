#!/usr/bin/env ruby
require 'brl/genboree/kb/kbDoc'
require 'brl/genboree/kb/mongoKbDatabase'
require 'brl/genboree/rest/helpers'
require 'brl/genboree/rest/resources/genboreeResource'
require 'brl/genboree/rest/data/textEntity'
require 'brl/genboree/rest/data/kbDocEntity'
require 'brl/genboree/kb/helpers/transformsHelper'


#--
module BRL ; module REST ; module Resources                # <- resource classes must be in this namespace
#++

  class KbTransforms < BRL::REST::Resources::GenboreeResource
    # @return [Hash{Symbol=>Object}] Map of what http methods this resource supports ( @{ :get => true, :put => false }@, etc } ).
    HTTP_METHODS = { :get => true }
    RSRC_TYPE = 'kbTransforms'
    
    # @api RestAPI INTERFACE. CLEANUP: Inheriting classes should also implement any specific
    #   cleanup that might save memory and aid GC. Their version should call {#super}
    #   so any parent {#cleanup} will be done also.
    # @return [nil]
    def cleanup()
      super()
      @groupId = @groupName = @groupDesc = nil
      @mongoKbDb = @mongoDbrcRec = @kbId = @kbName = @kbDbName = @collName = @docName = nil
    end

    # @api RestAPI INTERFACE. return a {Regexp} that will match a correctly formed URI for this service
    #   The pattern will be applied against the URI's _path_.
    # @returns [Regexp]
    def self.pattern()
      return %r{^/REST/#{VER_STR}/grp/([^/\?]+)/kb/([^/\?]+)/(?:trRulesDocs|transforms)$}
    end

    # @api RestAPI return integer from 1 to 10 that indicates whether the regexp/service is
    #   highly specific and should be examined early on, or whether it is more generic and
    #   other services should be matched for first.
    # @return [Fixnum] The priority, from 1 t o 10.
    def self.priority()
      return 7
    end

    # Perform common set up needed by all requests. Extract needed information,
    #   set up access to parent group/database/etc resource info, etc.
    # @return [Symbol] a {Symbol} corresponding to a standard HTTP response code [official English text, not the number]
    #   indicating success/ok (@:OK@), some other kind of success, or some kind of failure.
    def initOperation()
      initStatus = super()
      if(initStatus == :OK)
        @groupName  = Rack::Utils.unescape(@uriMatchData[1]).to_s.strip
        @kbName     = Rack::Utils.unescape(@uriMatchData[2]).to_s.strip
        initStatus = initGroupAndKb()
        #@type = @nvPairs.key?('type') ? @nvPairs['type'] : nil
      end
      return initStatus
    end
    
    
    # Process a GET operation on this resource.
    # @return [Rack::Response] instance configured and containing correct status code, message, and wrapped data;
    #   or containing correct error information.
    def get()
      initStatus = initOperation()
      if(initStatus == :OK)
        collName = BRL::Genboree::KB::Helpers::TransformsHelper::KB_CORE_COLLECTION_NAME
        @groupName = Rack::Utils.unescape(@uriMatchData[1])
        transformsHelper = @mongoKbDb.transformsHelper()
        unless(transformsHelper.coll.nil?)
          if(READ_ALLOWED_ROLES[@groupAccessStr])
            bodyData = BRL::Genboree::REST::Data::KbDocEntityList.new(@connect)
            mgCursor = transformsHelper.coll.find() #get all the documents in 'kbTransforms' collection
            docs = []
            if(mgCursor.count > 0)
              mgCursor.rewind!
              mgCursor.each {|doc|
                docs << BRL::Genboree::KB::KbDoc.new(doc)
              }
              docs.sort { |aa,bb|
                xx = aa.getPropVal('Transformation')
                yy = bb.getPropVal('Transformation')
                retVal = (xx.downcase <=> yy.downcase)
                retVal = (xx <=> yy) if(retVal == 0)
                retVal
              }
            else
              # then there are no transforms -- return empty array
            end
            docs.each {|doc|
              if(@detailed)
                entity = BRL::Genboree::REST::Data::KbDocEntity.new(@connect, doc)
              else
                entity = BRL::Genboree::REST::Data::KbDocEntity.new(@connect, { "text" => { "value" => doc.getPropVal('Transformation')} })
              end
              bodyData << entity
            }
            @statusName = configResponse(bodyData)
          else
            @statusName = :Forbidden
            @statusMsg = "You do not have sufficient permissions to perform this operation."
          end
        else
          @statusName = :'Not Found'
          @statusMsg = "NO_TRANSFORMATION_COLL: can't get documents because it appears to be no data collection #{collName.inspect} in the #{@kbName.inspect} GenboreeKB within group #{@groupName.inspect} . #{collName} is a GenboreeKB internal collection and absence of this collection means that the #{@kbName.inspect} is an outdated GenboreeKB."
        end
      end
      # If something wasn't right, represent as error
      @resp = representError() if(@statusName != :OK)
      return @resp
    end
  end
end ; end ; end # module BRL ; module REST ; module Resources

