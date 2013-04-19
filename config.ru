require 'rack/builder'
require 'simple_admin_auth'
require 'simple_admin_auth/rack'

app = Rack::Builder.new do
  use Rack::Session::Cookie, secret: 'your_secret_here'

  use SimpleAdminAuth::Builder do
    provider :google_apps, :domain => 'embarkmobile.com', :name => 'admin'
  end

  map "/admin" do
    use SimpleAdminAuth::Rack
    run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Welcome, you have been authenticated!']] }
  end

  map "/" do
    use SimpleAdminAuth::Application
    run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['Main site']] }
  end
end

run app
