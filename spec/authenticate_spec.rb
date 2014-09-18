require 'spec_helper'
require 'simple_admin_auth'
require 'simple_admin_auth/require_admin'

describe SimpleAdminAuth::Authenticate do

  let(:auth) do
    SimpleAdminAuth::Authenticate
  end

  let(:admin_session) do
    {
      admin_user:{
        email: 'admin@example.com',
        name: 'dummy'
      } 
    }
  end

  let(:invalid_session) do 
    {
      admin_user:{
        x_email: 'admin@example.com',
        x_name: 'dummy'
      } 
    }
  end

  let(:admin_string_sessions) do 
    {
      admin_user:{
        'email'=> 'admin@example.com',
        'name'=> 'dummy'
      } 
    }
  end

  before do
    SimpleAdminAuth::Configuration.email_white_list = nil
  end

  it 'should authenticate if admin email is set ' do 
    auth.is_admin?(admin_session).should eq(true)
  end

  it 'should authenticate if admin email is set in a string key' do 
    auth.is_admin?(admin_string_sessions).should eq(true)
  end

  it 'should not authenticate with empty session ' do 
    auth.is_admin?({}).should eq(false)
  end

  it 'should not authenticate if user is not white listed' do
    SimpleAdminAuth::Configuration.email_white_list = ['foo@bar.com']
    auth.is_admin?(admin_session).should eq(false)
  end

  it 'should authenticate if user is white listed' do
    SimpleAdminAuth::Configuration.email_white_list = ['admin@example.com']
    auth.is_admin?(admin_session).should eq(true)
  end

  it 'should not authenticate for none valid sessions' do
    auth.is_admin?(invalid_session).should eq(false)
  end
end