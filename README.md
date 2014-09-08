# SimpleAdminAuth

Add simple admin authentication to any Rails application, using Google Apps for authentication.

Authentication is done purely on the Google Apps domain - no user model is used. Other providers such as GitHub or
Facebook may also work, but are untested.

## Google Apps OAuth2

We recommend using OAuth2 to authenticate with Google Apps. You need to sign up for an API key on the
[Google APIs Console](https://code.google.com/apis/console/).

Make sure that you allow `/auth/admin/callback` as the redirect API, both for your development and production servers.
Example:

    http://localhost:3000/auth/admin/callback
    http://yourapp.com/auth/admin/callback


## Usage with Rails 3.x

Add these lines to your application's Gemfile:

    gem 'simple_admin_auth'
    gem 'omniauth-google-oauth2'

Create an `config/initializers/admin_auth.rb` configuring your domain:

    require 'omniauth/strategies/google_oauth2'

    Rails.application.config.middleware.use SimpleAdminAuth::Builder do
      # The name must be `admin`
      provider :google_oauth2, 'YOUR_KEY', 'YOUR_SECRET', name: 'admin',
              access_type: 'online', hd: 'example.com', approval_prompt: 'auto'
    end

If you would like to white list emails in your domain add the following:

    SimpleAdminAuth::Configuration.email_white_list = ['admin@example.com', 'john@example.com']

Protect any routes that require authentication:

    constraints SimpleAdminAuth::Authenticate do
      mount MongoRequestLogger::Viewer, :at => "/log"
    end

An user may be logged out by linking to `/auth/admin/logout`, or by clearing `session[:admin_user]`.

## Usage with Sinatra/Rack-based apps

Sample config.ru:

    require 'rack/builder'
    require 'simple_admin_auth'
    require 'simple_admin_auth/require_admin'
    require 'omniauth/strategies/google_oauth2'

    app = Rack::Builder.new do
      # Change this secret to something unique
      use Rack::Session::Cookie, secret: 'your_secret_here'

      use SimpleAdminAuth::Builder do
        # You need to create a key for your app on https://code.google.com/apis/console/
        # The name must be `admin`.
        provider :google_oauth2, 'YOUR_KEY (client id)', 'YOUR_SECRET', name: 'admin',
            access_type: 'online', hd: 'yourdomain.com', approval_prompt: 'auto'
      end


      map "/admin" do
        # This middleware only allows signed-in users to access this app.
        # This URL may be configured, and you may use the same middleware multiple times.
        use SimpleAdminAuth::RequireAdmin
        run lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Welcome, you have been authenticated!']] }
      end

      map "/" do
        # Any user may access this.
        run lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Main Site']] }
      end
    end

    run app

For a full example, see the config.ru in this repository.

## Alternative: Use OpenID

While this is simpler to configure, there are issues with SSL and other unresolved warnings, so we don't recommend this
 method.

Add the gem `omniauth-google-apps` to your Gemfile.

Use this in the initializer:

    require 'omniauth/strategies/google_apps'
    require 'openid/store/filesystem'
    require 'simple_admin_auth/openid_ssl'

    Rails.application.config.middleware.use SimpleAdminAuth::Builder do
      provider :google_apps, :domain => 'yourdomain.com', :name => 'admin',
        store: OpenID::Store::Filesystem.new('./tmp')
    end

Rack/Sinatra apps may be adapted similarly.

## Using in specific actions

The recommended method is to enable the authentication for a group of routes in routes.rb, or as middleware for a
specific Rack application. If however you need to use it for a specific page only, you can do the following:


    if !request.session[:admin_user].nil?
      true
    else
      request.session[:admin_login_return_url] = request.url
      raise SimpleAdminAuth::RedirectException.new('/auth/admin/login')
    end

In a Sinatra app, use `session` instead of `request.session`.

Note that this relies on internal behaviour of this gem, and might not be compatible with future versions.

## Changelog

### 0.1.1

* Allow whitelisting of emails. Contributed by @drubin.

### 0.1.0

* Recommend OAuth2 instead of OpenID.
* Add support for pure Rack/Sinatra applications.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
