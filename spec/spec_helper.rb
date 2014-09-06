require 'rspec'
require 'rack/test'

require 'simple_admin_auth'

include SimpleAdminAuth

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

OmniAuth.config.add_mock(:admin, {:uid => '12345', info:{ email: 'foo@bar.com'}})
OmniAuth.config.test_mode = true
