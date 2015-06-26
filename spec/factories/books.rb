FactoryGirl.define do
  factory :book do
    title "The red devil"
    author "tribeotk17"
    publish_date "2015-06-12"
    number_of_pages 100
    category
  end

  factory :many_books, class: Book do
    title Faker::Name.title
    author Faker::Name.name
    publish_date "2015-06-12"
    number_of_pages 100
    category
  end
end
