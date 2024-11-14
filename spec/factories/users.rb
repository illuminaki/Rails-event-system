# spec/factories/users.rb
FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        password { 'password123' }
        password_confirmation { 'password123' }
        confirmed_at { Time.current }
    end
end