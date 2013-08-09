module CouchRestAdapter
  class NotImplementedError < RuntimeError
    def to_s
      "An abstract class can not be instantiated."
    end
  end

  class InvalidDocument < RuntimeError
    def to_s
      "Document Can't be saved. Validation Failed."
    end
  end
end

