require 'rails_helper'

RSpec.describe 'FindForOauthService' do 
  let!(:user) { create(:user) }
  let(:mock_auth) { mock_auth_hash(:vkontakte, user.email) }
  let(:auth) { create(:authorization, user: user, linked_email: user.email, provider: mock_auth.provider, 
                               uid: mock_auth.uid, confirmed_at: Time.now) }
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
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates authorization for existed user' do
        expect { subject.call }.to change(user.authorizations, :count).by 1
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
      let(:mock_auth) { mock_auth_hash(:vkontakte) }
      let(:auth) { create(:authorization, linked_email: mock_auth.info.email, provider: mock_auth.provider, 
                               uid: mock_auth.uid, confirmed_at: Time.now) }
      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'creates authorization for this user' do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns new user' do
        expect(subject.call).to be_a(User)
      end
    end
  end
end
