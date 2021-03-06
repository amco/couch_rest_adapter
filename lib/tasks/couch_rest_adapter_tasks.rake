# desc "Explaining what the task does"
# task :couch_rest_adapter do
#   # Task goes here
# end
namespace :db do

  namespace :push do
    view_doc = {
      language: "coffeescript",
      views: {
        all: {
          map: "(d) ->\n  split_id = d._id.split('/')\n  t = split_id[0]\n  emit t, d._id\n",
        },
        by_attribute: {
          map: "(doc) ->\n  type = doc._id.split('/')[0]\n  for a of doc\n    emit([type, a, doc[a]], doc._id)\n"
        },
        by_type: {
          map: "(d)->\n  emit d.type.toLowerCase(), d._id if d.type\n"
        }
      }
    }

    desc "Will save the default design document."
    task :config do
      # TODO: DRY this methods, the need to have config yml file loaded prevent us to
      # add this on the namespace. Autoload didn;t work as expected.
      class BaseModel < CouchRestAdapter::Base
        use_default_database
      end

      doc_id = "_design/#{BaseModel.default_design_doc}"
      BaseModel.database.save_doc view_doc.merge( "_id" => doc_id )
      puts "Design document #{doc_id} added."
    end

    desc "Will update design document with what is on db/designs/*.coffee"
    task design: :environment do
      class BaseModel < CouchRestAdapter::Base
        use_default_database
      end

      path = File.join Rails.root, 'db', 'designs'
      files = Dir.glob("**/*.coffee")
      views = {}
      filters = {}

      files.each do |filename|
        name, key  = File.basename(filename).sub(/.coffee/i, '').split(/\./)
        key ||= 'map'
        data = File.read filename

        if key == 'filter'
          filters[name] ||= data
        else
          views[name] ||= {}
          views[name][key] = data
        end
      end

      view_doc = {
        '_id' => "_design/#{BaseModel.default_design_doc}",
        'language' => 'coffeescript',
        'views' => views,
        'filters' => filters
      }

      begin
        doc = BaseModel.database.get view_doc["_id"]

        hash_doc = doc.to_hash
        rev = hash_doc.delete('_rev')

        if hash_doc == view_doc
          puts 'everything up to date'
        else
          view_doc["_rev"] = rev
          puts 'updating design document'
          will_save = true
        end

      rescue RestClient::ResourceNotFound
        puts 'creating design document'
        will_save = true
      end

      BaseModel.database.save_doc view_doc if will_save
    end
  end

end

