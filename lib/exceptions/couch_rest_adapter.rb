module CouchRestAdapter
  class NotImplementedError < RuntimeError
    def to_s
      "An abstract class can not be instantiated."
    end
  end
end

