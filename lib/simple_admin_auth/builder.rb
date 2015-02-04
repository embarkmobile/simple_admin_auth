require 'omniauth'
require 'omniauth/builder'
require 'simple_admin_auth/application'

module SimpleAdminAuth
  class Builder < OmniAuth::Builder
    def initialize(*args)
      super(*args)

      use SimpleAdminAuth::LoginRedirect

      use Rack::Builder do
        map '/auth' do
          use SimpleAdminAuth::Application
        end
      end
    end
  end
end
