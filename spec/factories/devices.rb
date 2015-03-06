FactoryGirl.define do
  factory :device do
    user
    uuid     Faker::Lorem.characters(25)
    platform 'browser'
  end

end
