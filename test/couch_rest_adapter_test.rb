require 'test_helper'

class FooBar < CouchRestAdapter::Base
  use_default_database
end

class CouchRestAdapterTest < ActiveSupport::TestCase

  def setup
    resp = {ok: true, id: "foo_bar/1", rev: "FF0000"}
    FakeWeb.register_uri :put, %r|http://.*:5984/test/.*|, body: resp.to_json

    get_resp = {_id: 'foo_bar/1', _rev: 'FF0000', foo: 'Foo', bar: 'Bar'}

    FakeWeb.register_uri :get, %r|http://.*:5984/test/foo_bar.*|, body: get_resp.to_json

    view_by_type_resp = {
      total_rows:579,
      offset:0,
      rows:[
        {
          id:"foo_bar/1",
          key: "foo_bar",
          value: {_id: "foo_bar/1", _rev: "FF0000", foo: 'Foo', bar: 'Bar', type: 'foo_bar'},
          doc: {_id: "foo_bar/1", _rev: "FF0000", foo: 'Foo', bar: 'Bar', type: 'foo_bar'}
        }
      ]
    }

    view_resp = {
      total_rows:579,
      offset:0,
      rows:[
        {
          id:"foo_bar/1",
          key: "foo_bar",
          value: {_id: "foo_bar/1", _rev: "FF0000", foo: 'Foo', bar: 'Bar'},
          doc: {_id: "foo_bar/1", _rev: "FF0000", foo: 'Foo', bar: 'Bar'}
        }
      ]
    }

    FakeWeb.register_uri :get, %r|http://.*:5984/test/_design/.*/_view/all.*key=%22foo_bar%22|, body: view_resp.to_json

    FakeWeb.register_uri :get, %r|http://.*:5984/test/_design/.*/_view/by_type.*key=%22foo_bar%22|, body: view_by_type_resp.to_json

    FakeWeb.register_uri :get, %r|http://.*:5984/test/_design/.*/_view/by_attribute.*key=%5B%22foo_bar%22%2C%22foo%22%2C%22Foo%22%5D|, body: view_by_type_resp.to_json

    @foo = FooBar.new foo: 'Foo', bar: 'Bar'
    @foo.save
  end

  test 'can not instantiate base class' do
    assert_raise CouchRestAdapter::NotImplementedError do
      CouchRestAdapter::Base.new
    end
  end

  test 'will add class underscorename to id' do
    assert @foo.id =~ /foo_bar/
  end

  test 'attributes are available as methods' do
    assert_equal 'Bar', @foo.bar
    assert_equal 'Foo', @foo.foo
  end

  test 'one can update existing attributes' do
    @foo.foo = 'more'
    assert_equal 'more', @foo[:foo]
  end

  test 'update to attr= will persist' do
    skip "Need to test update methods with mock requests."
  end

  test 'query all will bring array of Foo instances' do
    foos = FooBar.all
    foos.each do |f|
      assert f.kind_of?(FooBar)
    end
  end

  test 'query all_by_type will return array of docs with type set to model name' do
    bar = FooBar.new foo: 'Bar', bar: 'Foo', type: 'foo_bar'
    bar.save
    bars = FooBar.all_by_type
    bars.each do |doc|
      assert doc.kind_of?(FooBar)
      assert_equal 'foo_bar', doc.type
    end
  end

  test 'find_by_attr will return array of docs with type set to model name' do
    bar = FooBar.new foo: 'Bar', bar: 'Foo', type: 'foo_bar'
    bar.save
    bars = FooBar.find_by_foo 'Foo'
    bars.each do |doc|
      assert doc.kind_of?(FooBar)
      assert_equal 'foo_bar', doc.type
    end
  end

  test 'find will work with partial id' do
    partial_id = @foo.id.sub(/foo\//,'')
    assert_equal @foo, FooBar.find(partial_id)
  end

  #TODO: Error handling, reporting

end

class LintTest < ActiveModel::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = FooBar.new
  end
end
