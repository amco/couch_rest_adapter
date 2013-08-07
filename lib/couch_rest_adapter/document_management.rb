using CouchRestAdapter::Helpers

#TODO write some tests for this module
module CouchRestAdapter
  module DocumentManagement
    module ClassMethods
      def namespace=(namespace)
        @_namespace = namespace
      end

      def namespace
        @_namespace ||= object_name
      end

      def object_name
        model_name.element
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    UUID_DOC = '_uuids/?'

    #override this method if you want to set your own id
    def set_id
      uuids.first
    end

    def uuids opts = {}
      uuid_doc = File.join UUID_DOC, query(opts)
      uuids_path = File.join CouchRestAdapter::Base.base_path, uuid_doc
      CouchRest.get( uuids_path )["uuids"]
    end

    def query opts = {}
      CGI.unescape(opts.to_query)
    end

    def _set_id_and_namespace
      self['_id'] = set_id if self['_id'].blank?
      self['_id'] = self['_id'].namespace_me self.class.namespace
    end

  end
end

