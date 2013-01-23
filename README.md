# SimpleAdminAuth

Add simple admin authentication to any Rails application, using Google Apps for authentication.

Authentication is done purely on the Google Apps domain - no user model is used.

## Usage

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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
