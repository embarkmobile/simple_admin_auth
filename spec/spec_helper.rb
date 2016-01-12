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

OmniAuth.config.test_mode = true
