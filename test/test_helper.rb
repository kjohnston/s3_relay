ENV["RAILS_ENV"] ||= "test"

IS_RAKE_TASK = (!! ($0 =~ /rake/))

if IS_RAKE_TASK
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "db"
    add_filter "test"
    add_filter "config"

    add_group "Services", "app/services"
    add_group "Uploaders", "app/services"
  end
end

require File.expand_path("../dummy/config/environment",  __FILE__)

Dir[File.join("./test/factories/*.rb")].sort.each { |f| require f }

require "rails/generators"
require "rails/test_help"
require "minitest/rails"
require "mocha/minitest"

Dir[File.join("./test/support/*.rb")].sort.each { |f| require f }
