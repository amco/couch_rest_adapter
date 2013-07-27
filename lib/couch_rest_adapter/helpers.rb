module CouchRestAdapter
  module Helpers
    refine String do
      def namespace_me name
        return self if self.empty?
        (self =~ /^#{name}\/.*/i) ? self : File.join(name, self)
      end
    end
  end
end

