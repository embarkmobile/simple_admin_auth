# This is an absolute minimal Rails application

require 'rails'
require 'action_controller/railtie'

class Dummy < Rails::Application
  config.session_store :cookie_store, :key => 'jiez4Mielu1AiHugog3shiiPhe3lai3faerooJohGo0rah5Mod'
  config.secret_token = 'ni6aeph6aeriBiphesh8omahv6cohpue5Quah5ceiMohtuvei8'

  config.logger = Logger.new(File.expand_path('../test.log', __FILE__))
  Rails.logger = config.logger

  config.middleware.use SimpleAdminAuth::Builder do
    provider :developer, name: 'admin'
  end

  module Actions
    class << self
      def index
        lambda do |env|
          [200, {'Content-Type' => 'text/html'}, ['Home']]
        end
      end

      def protected
        lambda do |env|
          [200, {'Content-Type' => 'text/html'}, ['Admin']]
        end
      end
    end
  end

  routes.draw do
    get '/'  => Dummy::Actions.index

    constraints SimpleAdminAuth::Authenticate do
      get '/protected/test'  => Dummy::Actions.protected
    end
  end
end

