require 'couch_rest_adapter'
require 'rails'

module CouchRestAdapter
  class Railtie < Rails::Railtie
    railtie_name :couch_rest_adapter

    rake_tasks do
      load 'lib/tasks/couch_rest_adapter_tasks.rake'
    end
  end
end
