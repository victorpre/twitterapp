def set_omniauth(opts = {})
  default = {:provider => :twitter,
             :uid     => "1234"}
             info = {:name => "Godofredo",:image => "http://www.aviatorcameragear.com/wp-content/uploads/2012/07/placeholder-470x352_normal.jpg"}
  default[:info]= OpenStruct.new info


  credentials = default.merge(opts)
  provider = credentials[:provider]
  user_hash = credentials[:info]

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[provider] = credentials
end

def set_invalid_omniauth(opts = {})

  credentials = { :provider => :facebook,
                  :invalid  => :invalid_crendentials
                 }.merge(opts)

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[credentials[:provider]] = credentials[:invalid]

end
