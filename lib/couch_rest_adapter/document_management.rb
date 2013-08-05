using CouchRestAdapter::Helpers

module CouchRestAdapter
  module DocumentManagement
    module ClassMethods
      def namespace=(namespace)
        @@_namespace = namespace
      end

      def namespace
        @@_namespace ||= object_name
      end

      def object_name
        model_name.singular
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    UUID_DOC = '_uuids/?'

    def next_id
      File.join self.class.object_name, uuids.first
    end

    def uuids opts = {}
      uuid_doc = File.join UUID_DOC, query(opts)
      uuids_path = File.join CouchRestAdapter::Base.base_path, uuid_doc
      CouchRest.get( uuids_path )["uuids"]
    end

    def query opts = {}
      CGI.unescape(opts.to_query)
    end

    def set_id
      self['_id'] = next_id if self['_id'].blank?
      self['_id'] = self['_id'].namespace_me self.class.namespace
    end
  end
end

