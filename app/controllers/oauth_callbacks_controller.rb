class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorization_check
  
  def vkontakte
    sign_in_via_provider('Vkontakte')
  end

  def verify_email
    verified_auth = Authorization.find_by_confirmation_token(params[:token])
    if verified_auth
      verified_auth.activate_email
      redirect_to new_user_session_path, notice: "Your account was succesfully verified. Now you can log in
      via #{verified_auth.provider.capitalize}"
    else
      redirect_to new_user_session_path, alert: "Something's wrong. Try confirming your mail again"
    end
  end

  def confirm_email
    pending_user = User.find_or_initialize_with_skip_confirmation(params[:email])
    if pending_user
      new_auth = pending_user.authorizations.first_or_initialize( provider: session[:auth]['provider'], 
                        uid: session[:auth]['uid'], name: session[:auth]['info']['name'], 
                        username: session[:auth]['info']['username'], city: session[:auth]['info']['city'], 
                        linked_email: params[:email]) do |pending_authorization|
        pending_authorization.confirmation_token = Devise.friendly_token[0, 20]
        pending_authorization.confirmation_sent_at = Time.now.utc
      end
      if new_auth.save
        OauthMailer.inform_about(new_auth).deliver_now
        redirect_to root_path, notice: "Great! You can confirm your address now, just check your email."
      else
        redirect_to root_path, alert: "Something's wrong. Try again later or sing in using different method."
      end 
    end
  end

  private

  def sign_in_via_provider(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    # if it's first auth without email
    unless @user || has_email?
      save_auth_info_to_session
      render 'oauth_callbacks/confirm_email'
    end
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: "Something went wrong, we couldn't sign you in via #{provider}" if has_email?
    end
  end

  def has_email?
    request.env['omniauth.auth']['info']['email'].present?
  end

  def save_auth_info_to_session
    session[:auth] = { uid: request.env['omniauth.auth']['uid'], provider: request.env['omniauth.auth']['provider'],
                       info: 
                            { name: request.env['omniauth.auth']['info']['name'], 
                              username: request.env['omniauth.auth']['info']['nickname'],
                              city: request.env['omniauth.auth']['info']['location'] } 
                      }
  end
end
