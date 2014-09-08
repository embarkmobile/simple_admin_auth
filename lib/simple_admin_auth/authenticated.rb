module SimpleAdminAuth
  def self.authenticate &block
    constraints(Authenticate) do
      yield
    end
  end

  class Authenticate
    def self.matches?(request)
      if is_admin?(request.session)
        true
      else
        request.session[:admin_login_return_url] = request.url
        raise RedirectException.new('/auth/admin/login')
      end
    end

    def self.is_admin?(session)
      valid_admin = false
      if !session[:admin_user].nil? && !session[:admin_user][:email].nil?
        email = session[:admin_user][:email]
        if !SimpleAdminAuth::Configuration.email_white_list.nil?
          if SimpleAdminAuth::Configuration.email_white_list.include?(email)
            valid_admin = true
          end
        else
          valid_admin = true
        end
      end
      valid_admin
    end
  end


  class Unauthenticated
    def self.matches?(request)
      !Authenticated.matches?(request)
    end
  end
end