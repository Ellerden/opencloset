class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    # User'd used this SM before to authorize, all confirmed
    exist_auth = Authorization.where(provider: @auth.provider, uid: @auth.uid.to_s).where.not(confirmed_at: nil).first
    return exist_auth.user if exist_auth
    #Proceed if SM account has email linked
    return unless @auth.info && @auth.info[:email]

    # Create new user or find User with this email exists but hasn't used this SM before
    user = User.find_or_initialize_with_skip_confirmation(@auth.info[:email])
    # Create authorization with this SM for user
    email = @auth.info[:email]
    full_name = @auth.info[:name] if @auth.info[:name].blank?
    username = @auth.info[:nickname] if @auth.info[:name].blank?
    city = @auth.info[:city] if @auth.info[:city].blank?
    
    user.authorizations.create(provider: @auth.provider, uid: @auth.uid, city: @auth.city, linked_email: email, name: full_name, username: username)
    user.update!(confirmed_at: Time.now) unless user.confirmed?
  end
end
