# SimpleAdminAuth

Add simple admin authentication to any Rails application, using Google Apps for authentication.

Authentication is done purely on the Google Apps domain - no user model is used.

## Usage with Rails 3.x

Add this line to your application's Gemfile:

    gem 'simple_admin_auth'

Create an initialiser configuring your domain:

    Rails.application.config.middleware.use SimpleAdminAuth::Builder do
      provider :google_apps, :domain => 'yourdomain.com', :name => 'admin'
    end

Protect any routes that require authentication:

    constraints SimpleAdminAuth::Authenticate do
      mount MongoRequestLogger::Viewer, :at => "/log"
    end

An user may be logged out by linking to `/auth/admin/logout`, or by clearing `session[:admin_user]`.

## Usage with Sinatra/Rack-based apps

Sample config.ru:

    require 'rack/builder'
    require 'simple_admin_auth'
    require 'simple_admin_auth/rack'
    require 'rack/cascade'

    app = Rack::Builder.new do
      use Rack::Session::Cookie, secret: 'change_me'

      use SimpleAdminAuth::Builder do
        provider :google_apps, :domain => 'yourdomain.com', :name => 'admin'
      end

      map "/your_protected_area" do
        use SimpleAdminAuth::Rack
        run YourProtectedArea.new
      end

      map "/" do
        run Rack::Cascade.new [
          YourMainSite.new,
          SimpleAdminAuth::Application
        ]
      end
    end

    run app


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
