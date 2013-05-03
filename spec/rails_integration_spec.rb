require 'spec_helper'
require 'simple_admin_auth'
require 'integration_examples'

begin
  require 'rails'

  # Configure the Rails application
  ENV["RAILS_ENV"] = "test"
  require 'dummy/application'


  describe "Rails Integration" do
    let(:app) do
      Rails.application
    end

    include_examples 'integration'
  end
rescue LoadError
  # Cannot find Rails - skip these tests
end
