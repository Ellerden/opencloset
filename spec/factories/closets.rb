FactoryBot.define do
  factory :closet do
    association :user
    name { "MyString" }
    open { false }
  end
end
