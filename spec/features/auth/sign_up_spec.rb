require 'rails_helper'

feature 'User can sign up', %q{
  In order to create closets, shop and sell
  As an unregistered User
  I'd like to be able to sign up
} do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  feature 'Unregistered user tries to register' do 
    scenario 'with errors' do
      click_on 'Sign up'
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end

    feature 'properly' do
      background do
        clear_emails
        fill_in 'Email', with: '1@1.com'
        fill_in 'Password', with: '123456'
        fill_in 'Password confirmation', with: '123456'
        click_on 'Sign up'
      end

      scenario 'sending confirmation email' do
        expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
      end

      scenario 'opening confirmation email' do
        open_email('1@1.com')
        expect(current_email).to have_content 'Welcome 1@1.com!'
        expect(current_email.subject).to eq 'Confirmation instructions'
      end
    end
  end

  scenario 'Already registered user tries to sign in' do 
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end
end
