FactoryBot.define do
  factory :authorization do
    association :user
    provider { "MyString" }
    uid { "MyString" }
    linked_email { 'test@test.ru' }
    name { "MyString" }
    nickname { "MyString" }
    location { "MyString" }
    confirmed_at { Time.now }
  end
end
