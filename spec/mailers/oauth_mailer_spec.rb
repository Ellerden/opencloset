require 'rails_helper'

RSpec.describe OauthMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:auth) { create(:authorization, user: user) }
  let(:mail) { OauthMailer.inform_about(auth) }

  it 'renders headers' do
    expect(mail.subject).to eq 'Confirm your email and open closet'
    expect(mail.from).to eq(['welcome@opencloset.ru'])
    expect(mail.to).to eq([user.email])
  end

  it 'renders body' do
    expect(mail.body.encoded).to match('CONFIRM')
  end
end
