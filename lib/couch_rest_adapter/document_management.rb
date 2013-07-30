module CouchRestAdapter
  module DocumentManagement
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

  end
end

