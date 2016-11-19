FactoryGirl.define do
    factory :user do
        sequence(:email) { |i| "tester_#{i}@gmail.com" }
        password 'password'
    end
end
