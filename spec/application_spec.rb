require 'spec_helper'

require 'simple_admin_auth/application'


describe Application do
  def app
    Application
  end

  it "should present a login screen" do
    get '/admin/login', nil, {}
    last_response.status.should eq(200)
    last_response.body.should match(/You need to sign in to continue\./)
  end

  it "should render a failure page" do
    get '/failure', nil, {}
    last_response.status.should eq(200)
    last_response.body.should match(/Authentication failed\./)
  end

end
