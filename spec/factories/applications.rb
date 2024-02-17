FactoryBot.define do
  factory :application do
    name {'name from factory bot'}
    sequence(:token) { |n| "Token123#{n}"}
  end
end