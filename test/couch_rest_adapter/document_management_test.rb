require 'test_helper'

class CouchRestAdapter::DocumentManagementTest < ActiveSupport::TestCase

  def setup
    @foo = FooBar.new
    @klass = @foo.class
    @bar = BarFoo.new.class
  end

  test 'class_method object_name returns model_name in singular form' do
    assert_equal @klass.object_name, @klass.model_name.singular
  end

  test 'class_method namespace defaults to object_name' do
    assert_equal @klass.namespace, @klass.object_name
    assert_equal @bar.namespace, @bar.object_name
  end

  test 'class_method namespace= allows override of namespace' do
    @klass.namespace = 'something'
    assert_equal @klass.namespace, 'something'
    @klass.namespace = @klass.object_name
  end

  test '_set_id_and_namespace will set the _id variable with an id and namespace' do
    @foo._set_id_and_namespace
    assert @foo['_id'].start_with?("foo_bar/")
  end
end

class FooBar < CouchRestAdapter::Base
  use_default_database
end

class BarFoo < CouchRestAdapter::Base
  use_default_database
end


