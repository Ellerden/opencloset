require 'rails_helper'

RSpec.describe OautrhCallbacksController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'Vkontakte' do
    it 'finds user from oauth data' do
      expect(User).to receive(:find_for_oauth)
      get :vkontakte
    end

    context 'User exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'logins user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end

    context 'User does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Twitter' do
  end
end
