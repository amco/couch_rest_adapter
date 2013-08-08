require 'active_model'
require 'couchrest'
require 'couch_rest_adapter/attribute_method'
require 'couch_rest_adapter/query_views'
require 'couch_rest_adapter/document_management'
require 'couch_rest_adapter/db_config'
require 'couch_rest_adapter/railtie' if defined?(Rails)

require File.join(File.dirname(__FILE__), '/exceptions/couch_rest_adapter')

using CouchRestAdapter::Helpers

module CouchRestAdapter
  class Base < CouchRest::Document
    #TODO: As abstract class should not have any method definition

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

    def initialize attributes = {}
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

    def self.respond_to? method
      (method.to_s =~ /^find_by_.*$/) ? true : super
    end

    def self.method_missing method, *args, &block
      if method.to_s =~ /^find_by_(.+)$/
        find_by_attribute($1, args.first, default_design_doc)
      else
        super
      end
    end

    def save
      return false if invalid?
      return false unless run_callbacks(:save)
      _set_id_and_namespace
      super
    end

    def method_missing method, *args, &block
      if attribute_methods.include? method.to_s
        read_write method, args.first
      elsif method.to_s =~ /^(.+)=$/
        read_write method, args.first
      else
        super
      end
    end

    def persisted?
      true
    end

    def read_attribute_for_validation(key)
      self[key.to_s]
    end

    protected
      def abstract?
        self.class.to_s == 'CouchRestAdapter::Base'
      end
  end
end
