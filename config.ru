require 'rack/builder'
require 'simple_admin_auth'
require 'simple_admin_auth/require_admin'
require 'omniauth/strategies/google_oauth2'

%w(GOOGLE_KEY GOOGLE_SECRET ADMIN_DOMAIN).each do |key|
  if ENV[key].nil?
    STDERR.puts "ENV[#{key}] is required"
    exit 1
  end
end

app = Rack::Builder.new do
  # Change this secret to something unique
  use Rack::Session::Cookie, secret: 'your_secret_here'

  use SimpleAdminAuth::Builder do
    # You need to create a key for your app on https://code.google.com/apis/console/
    provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'], name: 'admin',
        access_type: 'online', hd: ENV['ADMIN_DOMAIN'], approval_prompt: 'auto'
  end

  map "/admin" do
    # This middleware only allows signed-in users to access this app.
    use SimpleAdminAuth::RequireAdmin
    run lambda { |env| [200, {'Content-Type' => 'text/html'}, ['<p>Welcome, you have been authenticated!</p> <p><a href="/auth/admin/logout">Sign Out</a></p>']] }
  end

  map "/" do
    # Any user may access this.
    run lambda { |env| [200, {'Content-Type' => 'text/html'}, ['<p>Main site</p> <p><a href="/admin">Admin Area</a></p>']] }
  end
end

run app
