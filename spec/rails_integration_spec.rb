require 'spec_helper'
require 'simple_admin_auth'
require 'integration_examples'

describe "Rails Integration" do
  let(:app) do
    #Rails.application.config.middleware.use SimpleAdminAuth::Builder do
    #  provider :developer, name: 'admin'
    #end
    #
    #puts Rails.application.config.middleware.inspect

    #Dummy::Application
    Rails.application
  end


  include_examples 'integration'
end

