module CouchRestAdapter
  module DbConfig
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      attr_accessor :config_file

      def parse_config
        YAML::load( ERB.new( File.read(config_file) ).result)
      end

      def base_path
        parts = parse_config[Rails.env]
        "#{parts['protocol']}://#{parts['host']}:#{parts['port']}"
      end

      def full_path
        "#{base_path}/#{parse_config[Rails.env]['name']}"
      end

      def config_file
        root = Rails.root || File.expand_path("../../../test/dummy/",  __FILE__)
        File.join(root, 'config', 'couchdb.yml')
      end

      def default_design_doc
        parse_config[Rails.env]['design_doc']
      end
    end
  end
end
