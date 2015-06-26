FactoryGirl.define do
  factory :photo do
    book
    image Faker::Avatar.image
  end
end
