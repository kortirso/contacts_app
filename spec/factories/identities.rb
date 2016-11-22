FactoryGirl.define do
    factory :identity do
        uid '1830083693942463'
        provider 'facebook'
        association :user
    end
end
