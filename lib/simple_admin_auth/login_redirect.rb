module SimpleAdminAuth
  class LoginRedirect
    def initialize(app, options={})
      @app = app
    end

    def call(env)
      begin
        @app.call(env)
      rescue RedirectException => e
        [302, {"Location" => e.url}, ["Redirecting..."]]
      end
    end
  end

  class RedirectException < Exception
    attr_reader :url

    def initialize(url)
      @url = url
    end
  end
end