module OmniauthMacros
  def mock_auth_hash(provider, email = 'mockuser@test.com')
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during feature testing.
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider,
      uid: '12345',
      info: {
        name: 'mockuser',
        nickname: 'mockuser',
        location: 'mockcity',
        email: email  
      }
    })
  end
end
