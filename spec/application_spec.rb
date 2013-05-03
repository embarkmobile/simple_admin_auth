require 'spec_helper'

require 'simple_admin_auth/application'


describe Application do
  def app
    Application
  end

  it "should present a login screen" do
    get '/admin/login', nil, {}
    last_response.should be_ok
    last_response.body.should =~ /You need to sign in to continue\./
  end

  it "should render a failure page" do
    get '/failure', nil, {}
    last_response.should be_ok
    last_response.body.should =~ /Authentication failed\./
  end

end
