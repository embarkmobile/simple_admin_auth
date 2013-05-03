require 'rspec'
require 'rack/test'

require 'simple_admin_auth'

include SimpleAdminAuth

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end


OmniAuth.config.add_mock(:admin, {:uid => '12345'})
OmniAuth.config.test_mode = true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path('../dummy/application', __FILE__)
