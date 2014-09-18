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
      admin_session = get_session_key(session, :admin_user)
      valid_admin = false
      if !admin_session.nil? && !get_session_key(admin_session, :email).nil?
        email = get_session_key(admin_session, :email)
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

    private 
    def self.get_session_key(hash, symbol)
      (hash[symbol] || hash[symbol.to_s])
    end
  end


  class Unauthenticated
    def self.matches?(request)
      !Authenticated.matches?(request)
    end
  end
end