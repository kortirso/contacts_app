FactoryGirl.define do
    factory :contact do
        name 'Contact Name'
        sequence(:email) { |i| "contact_#{i}@gmail.com" }
        phone '555-55-55'
        address 'Address'
        company 'Big Company'
        association :user
    end
end
