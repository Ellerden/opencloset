class Authorization < ApplicationRecord
  belongs_to :user
  validates :provider, :uid, presence: true
  validates :uid, uniqueness: { scope: [:provider, :linked_email], 
                                message: 'This account with this email is already taken' }

  def activate_email
    transaction do
      self.update!(confirmed_at: Time.now)
      # if this email was already confirmed - maybe with another SM, we do nothing. if not - confirm user
      self.user.update!(confirmed_at: Time.now) unless self.user.confirmed?
      # update the fields from SM info if they were empty
      self.user.update!(name: self.name) if self.user.name.empty?
      self.user.update!(username: self.username) if self.user.username.empty?
      self.user.update!(city: self.city) if self.user.city.empty?
    end
  end

  def confirmed?
    self.confirmed_at?
  end
end
