require 'rails_helper'

feature 'User can sign out', %q{
  In order to stop creating closets, shop and sell
  As an authenticated User
  I'd like to sign out
} do
  given(:user) { create(:user) }
  background { sign_in(user) }

  scenario 'Authorized user tries to sign out' do
    click_on 'Log Out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
