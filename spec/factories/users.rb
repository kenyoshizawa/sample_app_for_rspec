FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "johndoe#{n}@example.com"}
    password { 'password' }
    password_confirmation { 'password' }
  end
end
