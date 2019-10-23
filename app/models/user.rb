class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[vkontakte]

  has_many :closets
  has_many :authorizations

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call  
  end

  def self.find_or_initialize_with_skip_confirmation(email)
    user = User.find_or_initialize_by(email: email) do |u|
      u.password = Devise.friendly_token[0..20]
      u.password_confirmation = u.password
    end

    user.skip_confirmation_notification!
    user if user.save
  end
end
