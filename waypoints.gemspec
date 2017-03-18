$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "waypoints/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "waypoints"
  s.version     = Waypoints::VERSION
  s.authors     = ["Erol Fornoles"]
  s.email       = ["erol.fornoles@gmail.com"]
  s.homepage    = "https://github.com/Erol/waypoints"
  s.summary     = "Waypoints"
  s.description = "Waypoints"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"
  s.add_dependency "ruby-graphviz", "~> 1.2.2"

  s.add_development_dependency "sqlite3"
end
