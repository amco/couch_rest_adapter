require 'couch_rest_adapter/helpers'

using CouchRestAdapter::Helpers

module CouchRestAdapter
  module QueryViews

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def find_by_attribute attr_name, value, doc_name
        document_name = 'by_attribute'
        key_value = [object_name, attr_name, value]
        view_by_key document_name, key_value, doc_name
      end

      def query_view name, doc_name
        view_by_key name, object_name, doc_name
      end

      def view_by_key name, key = nil, doc_name = nil
        doc = name.namespace_me(doc_name)
        view(doc, {key: key})['rows'].map{ |res| new res['doc'] }
      end

      def view doc, attrs, raw = true
        results = raw_view doc, attrs
        return results if raw
        results['rows'].map{ |row| new row['doc']}
      end

      #TODO: method for reduce, and filters
      def raw_view doc, attrs, reduce = false
        database.view(doc, {reduce: reduce, include_docs: true}.merge!(attrs) )
      end
    end

  end
end

