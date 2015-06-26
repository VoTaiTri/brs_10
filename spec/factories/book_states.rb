FactoryGirl.define do
  factory :book_state do
    user
    book
    state "unread"
  end
end
