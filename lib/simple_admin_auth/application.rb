require 'sinatra'

module SimpleAdminAuth
  class Application < Sinatra::Base
    enable :inline_templates
    set :raise_errors, true
    set :show_exceptions, false
    set :logging, nil

    def self.get_or_post(path, opts={}, &block)
      get(path, opts, &block)
      post(path, opts, &block)
    end

    get_or_post '/auth/admin/callback' do
      auth_hash = request.env['omniauth.auth']

      session[:admin_user] = auth_hash['info']

      return_url = session[:admin_login_return_url] || '/'
      session[:admin_login_return_url] = nil
      if admin?
        redirect return_url
      else
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    get '/auth/admin/logout' do
      return_to = params[:return_to] || '/'
      session[:admin_user] = nil
      redirect return_to
    end

    get '/auth/admin/login' do
      erb :login
    end

    get '/auth/admin/bootstrap.css' do
      send_file File.join(File.dirname(__FILE__), '../../static/css/bootstrap.min.css')
    end

    private


    def admin?
      !session[:admin_user].nil?
    end
  end
end

__END__

@@ login
<html>
<head><title>Admin Login</title>
  <link rel="stylesheet" href="/auth/admin/bootstrap.css" />
  <style type="text/css">
    body {
      background-color: #F9F9F9;
    }

    #content {
      text-align: center;
      margin: 200px auto;
    }
  </style>
</head>
<body>
<div id="content">
  <p>You need to sign in to continue.</p>
  <a class="btn btn-large" href="/auth/admin">Sign in via Google Apps</a>
</div>

</body>
</html>
