require 'active_model'
require 'couchrest'
require 'couch_rest_adapter/attribute_method'
require 'couch_rest_adapter/query_views'
require 'couch_rest_adapter/document_management'
require 'couch_rest_adapter/db_config'

require File.join(File.dirname(__FILE__), '/exceptions/couch_rest_adapter')

using CouchRestAdapter::Helpers

module CouchRestAdapter
  class Base < CouchRest::Document
    extend ActiveModel::Naming
    include ActiveModel::Validations
    include ActiveModel::Conversion
    include ActiveSupport::Callbacks
    include AttributeMethod
    include DbConfig
    include DocumentManagement
    include DbConfig
    include QueryViews

    #TODO: add custom callback calls.
    define_model_callbacks :save

    #TODO set_id not be a callback. Need a better way to do this, possibilty using class methods
    before_save :set_id

    def initialize attributes = {}
      @attributes = attributes
      raise NotImplementedError if abstract?
      super attributes
    end

    def self.all
      query_view('all', default_design_doc)
    end

    def self.all_by_type
      query_view('by_type', default_design_doc)
    end

    def self.find doc_id
      new database.get( doc_id.namespace_me(object_name) ).to_hash
    end

    def self.use_default_database
      use_database CouchRest.database(full_path)
    end

    def save
      return false if invalid?
      return false unless run_callbacks(:save)
      super
    end

    def method_missing method, *args, &block
      if attribute_methods.include? method.to_s
        read_write method, args.first
      else
        super
      end
    end

    def persisted?
      true
    end

    def read_attribute_for_validation(key)
      @attributes[key]
    end

    protected
      def abstract?
        self.class.to_s == 'CouchRestAdapter::Base'
      end

      def self.object_name
        self.model_name.singular
      end

      def set_id
        self['_id'] = next_id if self['_id'].blank?
      end
  end
end
