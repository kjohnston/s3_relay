$:.push File.expand_path("../lib", __FILE__)

require "s3_relay/version"

Gem::Specification.new do |s|
  s.name        = "s3_relay"
  s.version     = S3Relay::VERSION
  s.authors     = ["Kenny Johnston"]
  s.email       = ["kjohnston.ca@gmail.com"]
  s.homepage    = "http://github.com/kjohnston/s3_relay"
  s.summary     = "Direct uploads to S3 and ingestion by your Rails app."
  s.description = "Enables direct file uploads to Amazon S3 and provides a flexible pattern for
your Rails app to asynchronously ingest the files."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency "coffee-rails"
  s.add_runtime_dependency "rails", ">= 5.1"
  s.add_runtime_dependency "addressable", ">= 2.3.8" # URI.encode replacement

  s.add_development_dependency "guard-minitest", "~> 2.4",  ">= 2.4.6"
  s.add_development_dependency "minitest-rails", "~> 3.0.0", ">= 3.0.0"
  s.add_development_dependency "mocha",          "~> 1.2",  ">= 1.2.1"
  s.add_development_dependency "pg",             "~> 0.21", ">= 0.21.0"
  s.add_development_dependency "simplecov",      "~> 0.14",  ">= 0.14.1"
  s.add_development_dependency "thor"  # Bundler requirement
end
