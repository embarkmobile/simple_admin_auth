module SimpleAdminAuth
  class Rack
    def initialize(app, options={})
      @app = app
    end

    def call(env)
      if env['rack.session'][:admin_user]
        @app.call(env)
      else
        redirect_to = env['SCRIPT_NAME'] + env['PATH_INFO']
        env['rack.session'][:admin_login_return_url] = redirect_to
        [302, {"Content-Type"=>"text/plain", "Location" => '/auth/admin/login'}, ["Redirecting..."]]
      end
    end
  end
end
