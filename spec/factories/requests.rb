FactoryGirl.define do
  factory :request do
    user
    book_name Faker::Company.name
    author Faker::Name.name
    state "waiting"
  end
end
