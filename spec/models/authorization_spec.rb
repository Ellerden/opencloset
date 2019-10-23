require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  subject { create(:authorization) }
  it { should validate_uniqueness_of(:uid).scoped_to(:provider, :linked_email)
                                          .with_message("This account with this email is already taken") }


  describe '#activate_email' do
    let(:user) { create(:user, confirmed_at: nil) }
    let(:auth) { create(:authorization, user: user, name: 'John Snow', city: 'Westeros', confirmed_at: nil) }

    before { auth.activate_email }

    it 'updates confirmation status of auth and user, if it was not confirmed yet' do
      expect(auth).to be_confirmed
      expect(user).to be_confirmed
    end

    it 'updates users data from auth if it was empty' do
      expect(user.name).to eq 'John Snow'
      expect(user.city).to eq 'Westeros'
    end
  end

  describe '#confirmed?' do
    let(:user) { create(:user) }
    let(:auth) { create(:authorization, user: user) }

    it 'justifies that authorization is confirmed' do
      expect(auth).to be_confirmed
    end
  end
end
