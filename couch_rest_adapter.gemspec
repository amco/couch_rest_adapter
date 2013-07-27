$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "couch_rest_adapter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "couch_rest_adapter"
  s.version     = CouchRestAdapter::VERSION
  s.authors     = ["Javier Guerra"]
  s.email       = ["javierg@amcoonline.net"]
  s.homepage    = "https://github.com/amco/couch_rest_adapter"
  s.summary     = "Simple couchrest adapter."
  s.description = "Extends couchrest document and adds simple views and document management."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "couchrest", "~> 1.1.3"

  s.add_development_dependency "fakeweb", "~> 1.3.0"
  s.add_development_dependency "factory_girl_rails", "~> 4.2"
  s.add_development_dependency "mocha", "~> 0.4"
end
