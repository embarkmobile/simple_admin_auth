require 'omniauth'
require 'omniauth/builder'
require 'omniauth/strategies/google_apps'
require 'simple_admin_auth/application'

module SimpleAdminAuth
  class Builder < OmniAuth::Builder
    def initialize(*args)
      super(*args)

      use SimpleAdminAuth::LoginRedirect
      use SimpleAdminAuth::Application
    end
  end
end
