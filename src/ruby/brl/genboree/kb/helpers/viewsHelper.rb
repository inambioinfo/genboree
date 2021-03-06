#!/bin/env ruby

require 'brl/genboree/kb/helpers/abstractHelper'

module BRL ; module Genboree ; module KB ; module Helpers
  # This class assists with the document views for the various collections.
  # @note Views are subsets of the model for a collection.
  # @note Flat views are suitable for table display & output formats.
  class ViewsHelper < AbstractHelper
    # @return [String] The name of the core GenboreeKB collection the helper assists with.
    KB_CORE_COLLECTION_NAME = "kbViews"
    # @return [Array<Hash>] An array of MongoDB index config hashes; each has has key @:spec@ and @:opts@
    #   the indices for the view documents in the views collection.
    KB_CORE_INDICES =
    [
      # Index each view doc by its "name".
      {
        :spec => 'name.value',
        :opts => { :unique => true, :background => true }
      }
    ]
    IMPLICIT_VIEWS_DEFS = { 'Document Id Only' => { "type" => "flat", "description" => "", "viewProps" => [] } }
    # @return [Hash] A model document or model template which can be used to place an appropriate
    #    model document into the @kbModels@ collection when the database (or this helper's collection)
    #    is first created.
    KB_MODEL =
    {
      "name"        => { "value" => "View Model - #{KB_CORE_COLLECTION_NAME}", "properties" =>
      {
        "internal"  => { "value" => true },
        "model"     => { "value" =>
          {
            "name"        => "name",
            "description" => "The name of the data view.",
            "identifier"  => true,
            "properties"  =>
            [
              {
                "name"        => "type",
                "description" => "The name of the user data set (collection) this is a view for.",
                "required"    => true,
                "unique"      => true,
                "index"       => true
              },
              {
                "name"        => "description",
                "description" => "A description of the data view; what it views, who it's for, etc."
              },
              {
                "name"        => "implicitView",
                "description" => "Boolean property to indicate if view is a hard-coded (implicit) view or a user provided (explicit) view",
                "domain"      => "boolean",
                "required"    => true
              },
              {
                "name"        => "viewProps",
                "description" => "The actual data view schema.",
                "domain"      => "[valueless]",
                "required"    => true,
                "fixed"       => true,
                "items" =>
                [
                  {
                    "name" => "prop",
                    "identifier" => true,
                    "domain" => "regexp(\\S)",
                    "properties" => [
                      {
                        "name"     => "label"
                      }
                    ]
                  }
                ]
              }
            ]
          }
        }
      }}
    }

    # Create new instance of this helper.
    # @param [MongoKbDatabase] kbDatabase The KB database object this helper is assisting.
    # @param [String] collName The name of the document collection this helper uses.
    def initialize(kbDatabase, collName="kbViews")
      super(kbDatabase, collName)
      unless(collName.is_a?(Mongo::Collection))
        @coll = @kbDatabase.viewsCollection() rescue nil
      end
    end

    # Get the model doc template for the collection this helper assists with.
    # @todo change this from returning KB_MODEL constant
    #   in the respective sub-class, but rather have them loaded from
    #   some .yml files. Maybe cached like the SingletonJSONCache, etc.
    # @param [nil, Object] params Provide any parameters as individual arguments. Generally none are
    #   needed, except for some sub-classes that override this method and need some info.
    # @return [Hash] A suitable model template for the collection this helper assists with.
    def self.getModelTemplate(*params)
      return self::KB_MODEL
    end

    # Get a document template suitable for the collection this helper asists with.
    # @note The template should be filled in with sensible and convenient default
    #   values, but the calling code will have to fill in appropriate values to
    #   make it match the collection's model and possibily other constraints.
    # @param [String] collName The name of the data collection of interest. May
    #   be used to fill in key fields for collections that track info about other collections
    #   like @kbModels@ and @kbColl.metadata@.
    # @param [Hash, nil] params Additional parameters, if any, that can help fill out
    #   the template. For example, the model document for the collection of interest.
    # @return [Hash] the document template, partly filled in.
    def docTemplate(type='flat', *params)
      retVal =
      {
        "name"        => { "value" => "", "properties" =>
        {
          "type"         => { "value" => type},
          "implicitView" => { "value" => false},
          "description"  => { "value" => "" },
          "viewProps"    => { "items" => [] }
        }}
      }
      return retVal
    end
    
    # Transforms representation for requested/queried docs based on requested view
    # @param [Object] doc An instance of the BRL::Genboree::KB::KbDoc class
    # @param [Array] viewProps An array with paths to the properties in the view
    # @param [String] idPropName The document identifier property name 
    # @param [String] viewType 
    # @return [Hash] retVal A record from doc with the document identifier value and the values of the properties defined in the view
    def transformDoc(doc, viewProps, idPropName, viewType='flat')
      retVal = {}
      if(viewType == 'flat')
        viewProps.each { |prop| # prop is an object with 'value' and optional 'label' fields. 'value' is the property path. 
          val = nil
          propName = prop['value']
          # Begin block will throw exception if document does not have the nested prop defined in the view
          begin
            val = doc.getPropVal(propName)
            val = "[No Value]" if(val.nil?)
          rescue => err
            #$stderr.debugPuts(__FILE__, __method__, "STATUS", "Exception raised by KbDoc#getPropVal() has been caught by ViewsHelper#transformDoc(): THIS IS FINE. Just means the document does not have a value set (nested prop structure not defined) for the nested property defined in the value. WIll use [No Value] in the result.")
            val = "[No Value]"
          end
          if(prop.key?('label'))
            retVal[prop['label']] = { "value" => val }
          else 
            retVal[propName] = { "value" => val }
          end
        }
      else
        raise "Not Implemented"
      end
      return retVal
    end
    
    # Returns a document repreenting one of the 'implicit views'
    # @param [String] viewName Name of the implicit view
    # @return [Hash] templDoc A filled out hash representing the implicit view
    def getImplicitView(viewName)
      templDoc = docTemplate()
      viewDef = IMPLICIT_VIEWS_DEFS[viewName]
      templDoc['name']['value'] = viewName
      templDoc['name']['properties']['type']['value'] = viewDef['type']
      templDoc['name']['properties']['description']['value'] = viewDef['description']
      templDoc['name']['properties']['viewProps']['items'] = viewDef['viewProps']
      templDoc['name']['properties']['implicitView']['value'] = true
      return templDoc
    end
    
    # Performs special post validation checks of the view document
    # @param [Hash] doc The view document in hash form
    # @return [String] error The error string. Should be empty if no errors found.
    def postValidationCheck(doc)
      error = ""
      viewDocObj = BRL::Genboree::KB::KbDoc.new(doc)
      items = viewDocObj.getPropField('items', 'name.viewProps')
      items.each {|itemObj|
        propPath = itemObj['prop']['value']
        if(propPath =~ /\[/)
          error = "Property paths are not allowed to be under item lists currently." 
          break
        end
      }
      if(viewDocObj.getPropField('value', 'name.implicitView'))
        error = "Creating or updating implicit views is not allowed"
      end
      if(viewDocObj.getPropField('value', 'name.type') != 'flat')
        error = "Creating a non-flat view is not supported."
      end
      return error
    end
  
    
    def tabbedDoc(doc, viewProps, type='flat', addHeader=false)
      retVal = ""
      if(type == 'flat')
        # First construct the header line, if required
        if(addHeader)
          viewProps.each {|propObj|
            header = ( propObj.key?('label') ? propObj['label'] : propObj['value'] )
            retVal << "#{header}\t"
          }
          retVal << "\n"
        end
        viewProps.each {|propObj|
          propName = ( propObj.key?('label') ? propObj['label'] : propObj['value'] )
          retVal << "#{doc[propName]['value']}\t"
        }
        retVal << "\n"
      else
        raise "Not Implemented"
      end
      return retVal
    end


    # Get the version of a document from version collection this helper class assists with
    # @param [String] docID document identifier 
    # @param [String] ver version of interest - HEAD|CURR|PREV. 
    # @return [Fixnum] version of the document
    # @raise [ArgumentError] if @docID@ is not found in the collection
    # @todo add support for specific version
    def getDocVersion(docID, ver="HEAD")
      version = nil
      dbRef = nil
      versionList  = []
      versionDoc = nil
      identProp = KB_MODEL['name']['properties']['model']['value']['name']
      vh = @kbDatabase.versionsHelper(KB_CORE_COLLECTION_NAME)
      doc = vh.exists?(identProp, docID, KB_CORE_COLLECTION_NAME)
      unless(doc)
        raise ArgumentError, "DOC_NOT_FOUND: No document with the identifier #{docID} in the collection #{KB_CORE_COLLECTION_NAME}"
      end
      docIdObj = doc.getPropVal('versionNum.content')['_id']
      dbRef = BSON::DBRef.new(KB_CORE_COLLECTION_NAME, docIdObj)
      versionList = vh.allVersions(dbRef)
      if(ver == "HEAD" or ver == "CURR")
        versionDoc = versionList.last
      elsif (ver == "PREV")
        if(versionList.size > 1)
          versionDoc = versionList[versionList.size-2]
        else
          raise "No previous record found for the document - #{docID}"
        end
      else
        ver = ver.to_f
        versionDoc = vh.getVersion(ver, dbRef)
      end
      return versionDoc
    end



    
  end # class ViewsHelper
end ; end ; end ; end # module BRL ; module Genboree ; module KB ; module Helpers
