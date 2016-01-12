shared_examples "integration" do

  before(:each) do
    OmniAuth.config.add_mock(:admin, {:uid => '12345', info: {email: 'foo@bar.com'}})
  end

  after(:each) do
    SimpleAdminAuth::Configuration.required_hd = nil
  end

  it "should get the unprotected index page" do
    get '/'
    last_response.status.should == 200
    last_response.body.should =~ /Home/
    last_response.should be_ok
  end

  it "should present a login screen" do
    get '/auth/admin/login', nil, {}
    last_response.status.should == 200
    last_response.body.should =~ /You need to sign in to continue\./
    last_response.should be_ok
  end

  it "should redirect a protected page to the login page" do
    get '/protected/test'
    last_response.status.should == 302
    follow_redirect!
    last_request.url.should =~ /auth\/admin\/login$/
    last_response.status.should == 200
    last_request.env['rack.session'][:admin_login_return_url].should =~ /protected\/test$/
  end

  it "should login" do
    get '/protected/test'
    # Redirect to login page
    follow_redirect!

    # Click the login button
    get '/auth/admin'
    last_response.status.should == 302
    follow_redirect!

    # Mock strategy immediately redirects to the callback
    last_request.url.should =~ /auth\/admin\/callback$/
    follow_redirect!

    # We should be redirected back to the original page
    last_request.url.should =~ /\/protected\/test$/
    last_response.should be_ok
  end

  it "should fail when required hd is not present" do
    SimpleAdminAuth::Configuration.required_hd = 'example.org'

    get '/protected/test'
    # Redirect to login page
    follow_redirect!

    # Click the login button
    get '/auth/admin'
    last_response.status.should == 302
    follow_redirect!

    # Mock strategy immediately redirects to the callback
    last_request.url.should =~ /auth\/admin\/callback$/
    last_response.status.should == 401
  end

  it "should login if the required hd is present" do
    SimpleAdminAuth::Configuration.required_hd = 'example.org'
    OmniAuth.config.add_mock(:admin, {:uid => '12345', info: {email: 'foo@bar.com'}, extra: {id_info: {hd: 'example.org'}}})
    get '/protected/test'
    # Redirect to login page
    follow_redirect!

    # Click the login button
    get '/auth/admin'
    last_response.status.should == 302
    follow_redirect!

    # Mock strategy immediately redirects to the callback
    last_request.url.should =~ /auth\/admin\/callback$/
    follow_redirect!

    # We should be redirected back to the original page
    last_request.url.should =~ /\/protected\/test$/
    last_response.should be_ok
  end
end
