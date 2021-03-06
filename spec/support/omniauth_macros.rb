module OmniauthMacros
  def facebook_mock
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      provider: 'facebook',
      uid: '12345',
      info: {
        name: 'mockuser',
        email: 'sample@test.com'
      },
      credentials: {
        token: 'hogefuga'
      }
    )
  end

  def twitter_mock
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: '12345',
      info: {
        nickname: 'mockuser',
        email: 'sample@test.com'
      },
      credentials: {
        token: 'hogefuga'
      }
    )
  end

  def google_mock
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: '12345',
      info: {
        name: 'mockuser',
        email: 'sample@test.com'
      },
      credentials: {
        token: 'hogefuga'
      }
    )
  end
end
