class OauthMailer < Devise::Mailer
  default template_path: 'mailer' # to make sure that your mailer uses the devise views
  default from: 'welcome@opencloset.ru'

  def inform_about(auth)
    @url = "#{verify_email_url}?token=#{auth.confirmation_token}"
    @name = auth.name
    @provider = auth.provider
    mail(to: auth.user.email, subject: 'Confirm your email and open closet')
  end
end
