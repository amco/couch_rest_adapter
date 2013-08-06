require 'test_helper'

class CouchRestAdapter::AttributeMethodTest < ActiveSupport::TestCase

  def setup
    @foo = FooBar.new
  end

  test 'base_id' do
    @foo['_id'] = 'some_namespace/value_desired'
    assert_equal @foo.base_id, 'value_desired'
  end

end

class FooBar < CouchRestAdapter::Base
  use_default_database
end
