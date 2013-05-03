require 'spec_helper'
require 'simple_admin_auth'
require 'simple_admin_auth/require_admin'
require 'integration_examples'

describe "Rack Integration" do
  let(:app) do

    Rack::Builder.new do
      use Rack::Session::Cookie, secret: 'some_secret_this_is'

      use SimpleAdminAuth::Builder do
        provider :developer, name: 'admin'
      end

      map "/protected" do
        # This middleware only allows signed-in users to access this app.
        use SimpleAdminAuth::RequireAdmin
        run lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Admin']] }
      end

      map "/" do
        # Any user may access this.
        run lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Home']] }
      end
    end
  end

  include_examples 'integration'

end
