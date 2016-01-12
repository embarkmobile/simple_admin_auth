module SimpleAdminAuth
  class Configuration
    class << self
       attr_accessor :email_white_list
       # Set this to require a specific hosted domain (google oauth2 only)
       attr_accessor :required_hd
     end
  end
end
