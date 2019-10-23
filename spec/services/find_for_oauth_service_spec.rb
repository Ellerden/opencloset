require 'rails_helper'

RSpec.describe 'FindForOauthService' do 
  let!(:user) { create(:user) }
  let!(:auth) { OmniAuth.config.mock_auth[:vkontakte] }
  subject { FindForOauthService.new(auth) }

  context 'User already has authorization' do
    it 'returns the user' do
      user.authorizations.create!(provider: 'vkontakte', uid: '123456', linked_email: user.email,
      confirmed_at: Time.now)
      expect(subject.call).to eq user
    end
  end

  context 'User has no authorization' do
    context 'User already exists' do
      it 'does not create new user' do
        expect(subject.call).not_to change(User, :count)
      end

      it 'creates authorization for existed user' do
        expect(subject.call).to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'User does not exist' do
      it 'creates new user'
      it 'associates user email with provided auth email'
      it 'creates authorization for this user'
      it 'creates authorization with provider and uid'
      it 'returns the user'
    end
  end
end
