require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {FactoryGirl.build :user}
  let(:admin) {FactoryGirl.build :admin}
  subject {user}

  describe "Validates" do
    it {is_expected.to be_valid}
    it {expect(admin).to be_valid}
  end

  describe "Robot" do
    it {is_expected.to validate_presence_of(:name)}
    it {is_expected.to validate_length_of(:name).is_at_most(100)}
    it {is_expected.to validate_uniqueness_of(:name)}
    it {is_expected.to validate_presence_of(:role)}
    it {is_expected.to validate_length_of(:role).is_at_most(50)}
  end

  describe "Name" do
    context "when the name is blank" do
      before {subject.name = ""}
      it {is_expected.to have(1).error_on :name}
    end

    context "when the name is too long" do
      before {subject.name = Faker::Lorem.characters 101}
      it {is_expected.to have(1).error_on :name}
    end

    context "when the name is not uniqueness" do
      before {another_user = FactoryGirl.create :user, name: "VoTaiTri"}
      it {is_expected.not_to be_valid}
    end
  end

  describe "Role" do
    context "when the role is blank" do
      before {subject.role = ""}
      it {is_expected.to have(1).error_on :role}
    end

    context "when the role is too long" do
      before {subject.role = Faker::Lorem.characters 51}
      it {is_expected.to have(1).error_on :role}
    end
  end

  describe "Associations has_many" do
    it {is_expected.to have_many(:requests).dependent :destroy}
    it {is_expected.to have_many(:reviews).dependent :destroy}
    it {is_expected.to have_many(:comments).dependent :destroy}
    it {is_expected.to have_many(:book_states).dependent :destroy}
    it {is_expected.to have_many(:favorites).dependent :destroy}
    it {is_expected.to have_many(:likes).dependent :destroy}
    it {is_expected.to have_many(:activities).dependent :destroy}
  end

  describe "Associations active_relationships" do
    it {is_expected.to have_many(:active_relationships).class_name "Relationship"}
    it {is_expected.to have_many(:active_relationships).with_foreign_key "follower_id"}
    it {is_expected.to have_many(:active_relationships).dependent :destroy}
  end

  describe "Associations passive_relationships" do
    it {is_expected.to have_many(:passive_relationships).class_name "Relationship"}
    it {is_expected.to have_many(:passive_relationships).with_foreign_key "followed_id"}
    it {is_expected.to have_many(:passive_relationships).dependent :destroy}
  end

  describe "Associations following" do
    it do
      is_expected.to have_many(:following).
        through(:active_relationships).
        source :followed
    end
  end

  describe "Associations followers" do
    it do
      is_expected.to have_many(:followers).
        through(:passive_relationships).
        source :follower
    end
  end

  describe "scope search_by" do
    let(:rooney) {FactoryGirl.create :user, name: "Wayne Rooney", email: "rooney@gmail.com"}
    let(:martial) {FactoryGirl.create :user, name: "Anthony Martial", email: "martial@gmail.com"}
    let(:smalling) {FactoryGirl.create :user, name: "Chris Smalling", email: "smalling@gmail.com"}

    subject {User.search_by str}

    context "'m' character in name field" do
      let(:str) {"m"}
      it {is_expected.to eq [martial, smalling]}
    end

    context "'n' character in name field" do
      let(:str) {"n"}
      it {is_expected.to include rooney}
    end
  end

  describe "#is_admin?" do
    it {expect(admin).to be_is_admin}
  end

  describe "#is_user?" do
    it {expect(user.is_user? user).to eq true}
  end

  describe "following? and follow/unfollow another user" do
    let (:degea) {FactoryGirl.create :user, id: 1, email: "degea@gmail.com", name: "David Degea"}
    let (:carrick) {FactoryGirl.create :user, id: 16, email: "carrick@gmail.com", name: "Michael Carrick"}
    let (:blind) {FactoryGirl.create :user, id: 17, email: "blind@gmail.com", name: "Daley Blind"}

    before do
      subject.follow degea
      subject.follow carrick
    end

    it {expect(subject.following_ids).to eq [1, 16]}
    it {is_expected.to be_following carrick}
    it {expect {subject.follow blind}.to change(Relationship, :count).by 1}
    it {expect {subject.follow blind}.to change(Activity, :count).by 1}
    it {expect {subject.unfollow degea}.to change(Relationship, :count).by -1}
    it {expect {subject.unfollow degea}.to change(Activity, :count).by 1}
  end

  describe "to_param" do
    let(:another_user) {FactoryGirl.create :user, id: 3, email: "tribeo@gmail.com", name: "Tri Beo"}
    it {expect(another_user.to_param).to eq "3-tri-beo"}
  end

  describe "favorite? book" do
    let (:rojo) {FactoryGirl.build :user, id: 5, email: "rojo@gmail.com", name: "Marcos Rojo"}
    let (:book1) {FactoryGirl.build :book, id: 1}
    let (:book2) {FactoryGirl.build :book, id: 2}
    let! (:favorite) {FactoryGirl.create :favorite, book: book1, user: rojo}

    it {expect(rojo).to be_favorite book1}
    it {expect(rojo).not_to be_favorite book2}
  end

  describe "create activity" do
    let (:mata) {FactoryGirl.create :user, id: 8, email: "mata@gmail.com", name: "Juan Mata"}
    let (:book) {FactoryGirl.create :book, id: 1}
    let (:review) {FactoryGirl.create :review, id: 1}
    let (:request) {FactoryGirl.create :request, id: 1, user: mata}
    let (:comment) {FactoryGirl.create :comment, id: 1, user: mata, review: review}

    it {expect {mata.create_activity(mata.id, "follow")}.to change(Activity, :count).by 1}
    it {expect {mata.create_activity(mata.id, "unfollow")}.to change(Activity, :count).by 1}
    it {expect {mata.create_activity(review.id, "review")}.to change(Activity, :count).by 1}
    it {expect {mata.create_activity(book.id, "reading")}.to change(Activity, :count).by 1}
    it {expect {mata.create_activity(book.id, "read")}.to change(Activity, :count).by 1}
    it {expect {mata.create_activity(book.id, "favorite")}.to change(Activity, :count).by 1}
    it {expect {mata.create_activity(book.id, "unfavorite")}.to change(Activity, :count).by 1}
    it {expect {mata.create_activity(request.id, "request")}.to change(Activity, :count).by 1}
    it {expect {mata.create_activity(comment.id, "comment")}.to change(Activity, :count).by 1}
  end
end
