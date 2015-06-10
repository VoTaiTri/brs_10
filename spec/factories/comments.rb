FactoryGirl.define do
  factory :comment do
    user
    review
    content Faker::Lorem.sentence
  end
end
