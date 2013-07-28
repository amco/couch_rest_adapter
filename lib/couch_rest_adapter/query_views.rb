require 'couch_rest_adapter/helpers'

using CouchRestAdapter::Helpers

module CouchRestAdapter
  module QueryViews

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      #TODO: We can get this from Rails.application.class.name
      DEFAULT_DESIGN = 'amcoid'

      def query_view name, doc_name = nil
        doc = name.namespace_me(DEFAULT_DESIGN || doc_name)
        view(doc, {key: model_name})['rows'].map{ |res| new res['doc'] }
      end

      #TODO: method for reduce, and filters
      def view doc, attrs, reduce = false
        database.view(doc, {reduce: reduce, include_docs: true}.merge!(attrs) )
      end
    end

  end
end

