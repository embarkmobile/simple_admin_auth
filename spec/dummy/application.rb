# This is an absolute minimal Rails application

require 'rails'
require 'action_controller/railtie'

class Dummy < Rails::Application
  config.session_store :cookie_store, :key => 'jiez4Mielu1AiHugog3shiiPhe3lai3faerooJohGo0rah5Mod'
  config.secret_token = 'ni6aeph6aeriBiphesh8omahv6cohpue5Quah5ceiMohtuvei8'
  config.secret_key_base = '62773890cad9d9d584b57320f8612f8f7378a90aadcabc638d1c10b0262cf533f76a91c715b396b6cc46d81bbea001d82f5b6d8e670cc09be2e30abd6f5ec9ce'

  config.logger = Logger.new(File.expand_path('../test.log', __FILE__))
  Rails.logger = config.logger

  config.middleware.use SimpleAdminAuth::Builder do
    provider :developer, name: 'admin'
  end

  routes.draw do
    get '/'  => 'dummy#index'

    constraints SimpleAdminAuth::Authenticate do
      get '/protected/test' => 'dummy#protected'
    end
  end
end

class DummyController < ActionController::Base
  def index
    render text: 'Home'
  end

  def protected
    render text: 'Admin'
  end
end
