ENV["RAILS_ENV"] = "test"

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

ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment",  __FILE__)

Dir[File.join("./test/factories/*.rb")].sort.each { |f| require f }

require "minitest/autorun"
require "rails/generators"
require "minitest/rails"
require "minitest/pride"

Dir[File.join("./test/support/*.rb")].sort.each { |f| require f }
