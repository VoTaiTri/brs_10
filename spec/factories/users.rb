FactoryGirl.define do
  factory :admin, class: User do
    sequence(:name) {Faker::Company.name}
    email "admin@gmail.com"
    password "123456"
    password_confirmation "123456"
    role "admin"
  end

  factory :user do
    name "Vo Tai Tri"
    email "vtt@gmail.com"
    password "123456"
    password_confirmation "123456"
    role "normal"
  end
end
