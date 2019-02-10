$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "event_sourcery/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "event_sourcery-rails"
  spec.version     = EventSourcery::Rails::VERSION
  spec.authors     = ["Baylor Rae'"]
  spec.email       = ["baylor@thecodedeli.com"]
  spec.homepage    = "https://github.com/baylorrae/event_sourcery-rails"
  spec.summary     = "Combining two great powers of the code, data and web."
  spec.description = "Event Sourcery with the conventions of Rails. Because combining two great powers is always better than not."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2"

  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "rspec-rails", "~> 3.8"
  spec.add_development_dependency "ammeter", "~> 1.1"
end
