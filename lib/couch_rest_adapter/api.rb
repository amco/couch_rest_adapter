require 'couchrest'
require 'couchrest/rest_api'

module CouchRest
  module RestAPI
    def parse_response result, opts = {}
      JSON.parser = JSON::Ext::Parser
      (opts.delete(:raw) || opts.delete(:head)) ? result : JSON.parse(result)
    end
  end
end
