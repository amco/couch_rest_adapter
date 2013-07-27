require 'couchrest'
require 'couch_rest_adapter/attribute_method'
require 'couch_rest_adapter/query_views'
require 'couch_rest_adapter/document_management'
require 'couch_rest_adapter/db_config'

require File.join(File.dirname(__FILE__), '/exceptions/couch_rest_adapter')

using CouchRestAdapter::Helpers

module CouchRestAdapter
  class Base < CouchRest::Document
    include ActiveSupport::Callbacks
    include AttributeMethod
    include QueryViews
    include DocumentManagement
    include DbConfig

    #TODO: add custom callback calls.
    define_callbacks :before_save

    def initialize attrs = nil
      raise NotImplementedError if abstract?
      super attrs
    end

    def self.all
      query_view('all')
    end

    def self.all_by_type
      query_view('by_type')
    end

    def self.find doc_id
      new database.get( doc_id.namespace_me(model_name) ).to_hash
    end

    def self.use_default_database
      use_database CouchRest.database(full_path)
    end

    def save
      run_callbacks :before_save do
        self['_id'] = next_id if self['_id'].blank?
        super
      end
    end

    def method_missing method, *args, &block
      if attribute_methods.include? method.to_s
        read_write method, args.first
      else
        super
      end
    end

    protected
      def abstract?
        self.class.to_s == 'CouchRestAdapter::Base'
      end

      def self.model_name
        name.underscore
      end

  end
end
