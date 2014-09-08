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

    get_or_post '/admin/callback' do
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

    get '/failure' do
      erb :failure
    end

    get '/admin/logout' do
      return_to = params[:return_to] || '/'
      session[:admin_user] = nil
      redirect return_to
    end

    get '/admin/login' do
      erb :login
    end

    get '/admin/bootstrap.css' do
      send_file File.join(File.dirname(__FILE__), '../../static/css/bootstrap.min.css')
    end

    private


    def admin?
      SimpleAdminAuth::Authenticate.is_admin?(session)
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
  <a class="btn btn-large" href="/auth/admin">Sign in</a>
</div>

</body>
</html>

@@ failure
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
  <p>Authentication failed.</p>
  <a class="btn btn-large" href="/auth/admin">Sign in</a>
</div>

</body>
</html>
