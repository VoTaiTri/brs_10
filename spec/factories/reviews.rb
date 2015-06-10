FactoryGirl.define do
  factory :review do
    user
    book
    content Faker::Lorem.sentence
    rating Faker::Number.digit
  end
end
