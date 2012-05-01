# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "qqq"
    sequence(:email){ |n| "foo#{n}@bar.com" }
    password '12341234'
    confirmation_token 'bzmYquopFq9xUGCNyJzT'
  end
end
