module SimpleAdminAuth
  def self.authenticate &block
    constraints(Authenticate) do
      yield
    end
  end

  class Authenticate
    def self.matches?(request)
      if !request.session[:admin_user].nil?
        true
      else
        request.session[:admin_login_return_url] = request.url
        raise RedirectException.new('/auth/admin/login')
      end

    end
  end


  class Unauthenticated
    def self.matches?(request)
      !Authenticated.matches?(request)
    end
  end
end