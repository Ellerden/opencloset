require 'rails_helper'

feature 'User can sign in via social networks', %q{
  In order to not separately register on site
  I'like to use my existing social media accounts
  To quickly sign in and create/browse closets with clothes
} do
  describe 'User signs via Vkontakte' do
    context 'New user signs in using Vkontakte for the 1st time' do
      scenario 'No email confirmation needed' do
        visit new_user_session_path
        expect(page).to have_link('Sign in with Vkontakte')
        mock_auth_hash(:vkontakte)
        click_on 'Sign in with Vkontakte'

        expect(page).to have_content('mockuser@test.com')
        expect(page).to have_content('Successfully authenticated from Vkontakte account')
      end

      context 'Email confirmation needed' do
        scenario 'User does not provide email' do
          mock_auth_hash(:vkontakte, nil)
          visit new_user_session_path
          click_on 'Sign in with Vkontakte'
          expect(page).to have_content("It seems like we don't have your email")
          click_on 'Confirm'
          expect(current_path).to eq confirm_email_path
        end

        scenario 'Email provides email, confirms it and tries to log in via Vkontakte' do
          visit new_user_session_path
          mock_auth_hash(:vkontakte, nil)
          visit new_user_session_path
          click_on 'Sign in with Vkontakte'
          fill_in 'email', with: 'test@test.com'
          click_on 'Confirm'
          expect(page).to have_content("Great! You can confirm your address now, just check your email.")

          # work with email
          open_email('test@test.com')
          expect(current_email.subject).to eq "Confirm your email and open closet"
          expect(current_email).to have_link('CONFIRM')
          current_email.click_link 'CONFIRM'
          clear_emails
          expect(page).to have_content("Your account was succesfully verified. Now you can log in via Vkontakte")

          # log in via Vkontakte after confirming email
          click_on 'Sign in with Vkontakte'
          expect(page).to have_content('test@test.com')
          expect(page).to have_content('Successfully authenticated from Vkontakte account')
        end 
      end
    end

    context 'User somehow already exists' do
      given!(:user) { create(:user, confirmed_at: Time.now) }

      scenario 'Already hab been authorized via VK before and uses VK to authorize again' do
        auth = mock_auth_hash(:vkontakte, user.email)
        authorization = create(:authorization, user: user, linked_email: user.email, provider: auth.provider, 
                               uid: auth.uid, confirmed_at: Time.now)
        visit new_user_session_path
        click_on 'Sign in with Vkontakte'
        expect(page).to have_content(user.email)
        expect(page).to have_content('Successfully authenticated from Vkontakte account')
      end

      scenario 'Existing user signs in via Vkontakte for the 1st time' do
        auth = mock_auth_hash(:vkontakte, user.email)
        visit new_user_session_path
        click_on 'Sign in with Vkontakte'
        expect(page).to have_content(user.email)
        expect(page).to have_content('Successfully authenticated from Vkontakte account')


      end
    end
  end
end
