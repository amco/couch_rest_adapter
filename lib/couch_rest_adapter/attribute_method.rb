module CouchRestAdapter
  module AttributeMethod

    def read_write method, value = nil
      writer?(method) ? write_value(method, value) : read_value(method)
    end

    def read_value method_name
      singleton_class.class_eval do
        define_method(method_name) { self[method_name] }
      end
      send(method_name)
    end

    def write_value method_name, value
      base_method_name = method_without_equals(method_name)
      singleton_class.class_eval do
        define_method(method_name) do |v|
          self[base_method_name] = v
          @attributes[base_method_name] = v
        end
      end
      send(method_name, value)
    end

    def method_without_equals method_name
      method_name.to_s.sub(/=$/,'').to_sym
    end

    def writer? method_name
      method_name =~ /=$/
    end

    def attribute_methods
      _attributes.keys.map{ |attr| [attr, "#{attr}="] }.flatten
    end

  end
end

