require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:closets) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }
    let(:service) { double('Our service for find for oauth') }

    it 'calls FindForOuathService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end

    # context 'user already has authorization' do
    #   it 'returns the user' do
    #     user.authorizations.create(provider: 'vkontakte', uid: '123456')
    #     expect(User.find_for_oauth(auth)).to eq user
    #   end
    # end
  end

  describe '.find_or_initialize_with_skip_confirmation' do
    let!(:user) { create(:user) }

    it 'finds existing user' do
      expect(User.find_or_initialize_with_skip_confirmation(user.email)).to eq user
    end

    it 'creates new user' do
      expect { User.find_or_initialize_with_skip_confirmation('new@email.ru') }.to change(User, :count).by 1
    end

    it 'sends no confirmation letter to new user' do
      expect{ User.find_or_initialize_with_skip_confirmation('new@email.ru') }.not_to change { ActionMailer::Base.deliveries.count }
    end
  end
end
