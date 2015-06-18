puts "seed admin"
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             role: "admin")

puts "seed 10 users"
10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              "password",
               password_confirmation: "password")
end

15.times do |n|
  content = Faker::Name.title + " #{n + 1}"
  image = "default_category.png"
  Category.create! content: content, image: image
end

categories = Category.order(:created_at).take(10)
15.times do |n|
  categories.each do |category|
    book = Faker::Name.title + "#{category.id}.#{n + 1}"
    author = Faker::Name.name
    img = "default_book.png"
    Book.create! title: book, author: author, publish_date: "2015-03-17", number_of_pages: 300, image: img, category_id: category.id
  end
end

3.times do |n|
  content = Faker::Lorem.paragraph
  Review.create! user: User.first, book: Book.first, content: content, rating: 5
end

# Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each {|followed| user.follow(followed)}
followers.each {|follower| follower.follow(user)}