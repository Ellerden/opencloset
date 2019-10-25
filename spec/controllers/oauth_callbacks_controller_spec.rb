require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'Vkontakte' do
    context 'User exists' do
      let(:user) { create(:user) }

      context 'Vkontakte provides an email' do
        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          # get :vkontakte
          request.env["omniauth.auth"] = mock_auth_hash(:vkontakte, user.email)
          get :vkontakte
        end

        it 'logins user if it exists' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root' do
          expect(response).to redirect_to root_path
        end
      end

      context 'Vkontakte does NOT provide an email' do
        before do
          request.env["omniauth.auth"] = mock_auth_hash(:vkontakte, email = nil)
          get :vkontakte
        end

        it 'renders confirm email page' do
          expect(response).to render_template('oauth_callbacks/confirm_email')
        end

        it 'does not authorize without confirmation' do
          expect(subject.current_user).to be_nil
        end
      end
    end

    context 'User does not exist' do
      context 'Vkontakte provides an email' do
        before do
          request.env["omniauth.auth"] = mock_auth_hash(:vkontakte)
          get :vkontakte
        end

        it 'redirects to root' do
          expect(response).to redirect_to root_path
        end

        it 'logins new user' do
          user = User.find_by(email: 'mockuser@test.com')
          expect(subject.current_user).to eq user
        end
      end

      context 'Vkontakte does NOT provide an email' do
        before do
          request.env["omniauth.auth"] = mock_auth_hash(:vkontakte, email = nil)
          get :vkontakte
        end

        it 'renders confirm email page' do
          expect(response).to render_template('oauth_callbacks/confirm_email')
        end

        it 'does not authorize without confirmation' do
          expect(subject.current_user).to be_nil
        end
      end
    end
  end

  describe 'POST #confirm_email' do
    before do
      request.env["omniauth.auth"] = mock_auth_hash(:vkontakte)
      get :vkontakte
    end

    let(:confirm_email) { post :confirm_email, params: { email: 'mockuser@test.com' }, 
                                                         session: { auth: request.env["omniauth.auth"] } }

    it 'redirects to root path' do
      confirm_email
      expect(response).to redirect_to root_path
    end

    it 'sends an email' do
      expect { confirm_email }.to change{ ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe 'GET #verify_email' do
    context 'with valid attributes' do
      let(:auth) { create(:authorization, confirmed_at: nil, confirmation_token: Devise.friendly_token[0, 20]) }
      let(:token) { auth.confirmation_token }

      before { get :verify_email, params: { token: token } }

      it 'sets authorization confirmation status to true' do
        auth.reload
        expect(auth).to be_confirmed
      end

      it 'redirects to new user session path with success' do
        expect(response).to redirect_to new_user_session_path
        expect(flash[:notice]).to match(/Your account was succesfully verified.*/)
      end
    end

    context 'with invalid attributes' do
      it 'redirects to new user session path with fail' do
        get :verify_email, params: { provider: nil, uid: nil, token: nil }
        expect(response).to redirect_to new_user_session_path
        expect(flash[:alert]).to match(/Something's wrong. Try confirming your mail again*/)
      end
    end
  end
end
