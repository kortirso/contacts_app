FactoryGirl.define do
    factory :contact do
        name 'Contact Name'
        sequence(:email) { |i| "contact_#{i}@gmail.com" }
        phone '555-55-55'
        address 'Address'
        company 'Big Company'
        birthday '02/08/2000'
        association :user

        trait :empty_name do
            name ''
        end

        trait :empty_email do
            email ''
        end
    end
end
