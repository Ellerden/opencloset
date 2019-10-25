require 'rails_helper'

RSpec.describe ProfileController, type: :controller do
  describe '#show' do
    context 'When profile exists' do
      let(:user) { create(:user) }
      before { get :show, params: { id: user } }
      
      it 'shows current users profile info to everyone' do
        expect(response).to render_template :show
      end
    end

    context 'When profile does not exist' do
      before { get :show, params: { id: '404' } }
      
      it 'alerts that user is not found' do
        expect(flash[:alert]).to match(/Something went wrong - there is no such user*/)
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
