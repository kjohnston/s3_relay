$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "s3_relay/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "s3_relay"
  s.version     = S3Relay::VERSION
  s.authors     = ["Kenny Johnston"]
  s.email       = ["kjohnston.ca@gmail.com"]
  s.homepage    = "http://github.com/kjohnston/s3_relay"
  s.summary     = "Direct uploads to S3 and ingestion by your Rails app."
  s.description = "Direct uploads to S3 and ingestion by your Rails app."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "coffee-rails"
  s.add_dependency "rails"

  s.add_development_dependency "guard-minitest", "~> 2.3.2"
  s.add_development_dependency "minitest-rails", "~> 2.1.0"
  s.add_development_dependency "mocha",          "~> 1.1.0"
  s.add_development_dependency "simplecov",      "~> 0.9.1"
end
