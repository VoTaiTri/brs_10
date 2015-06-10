require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {FactoryGirl.build :user}

  subject {user}

  describe "Validates" do
    let(:admin) {FactoryGirl.build :admin}
    it {expect(user).to be_valid}
    it {expect(admin).to be_valid}
  end

  describe "Robot" do
    it {expect(user).to validate_presence_of(:name)}
    it {expect(user).to validate_length_of(:name).is_at_most(100)}
    it {expect(user).to validate_uniqueness_of(:name)}
    it {expect(user).to validate_presence_of(:role)}
    it {expect(user).to validate_length_of(:role).is_at_most(50)}
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
      before {@another_user = FactoryGirl.create :user, name: "VoTaiTri"}
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
    it {expect(user).to have_many(:requests).dependent :destroy}
    it {expect(user).to have_many(:reviews).dependent :destroy}
    it {expect(user).to have_many(:comments).dependent :destroy}
    it {expect(user).to have_many(:book_states).dependent :destroy}
    it {expect(user).to have_many(:favorites).dependent :destroy}
    it {expect(user).to have_many(:likes).dependent :destroy}
    it {expect(user).to have_many(:activities).dependent :destroy}
  end

  describe "Associations active_relationships" do
    it {expect(user).to have_many(:active_relationships).class_name "Relationship"}
    it {expect(user).to have_many(:active_relationships).with_foreign_key "follower_id"}
    it {expect(user).to have_many(:active_relationships).dependent :destroy}
  end

  describe "Associations passive_relationships" do
    it {expect(user).to have_many(:passive_relationships).class_name "Relationship"}
    it {expect(user).to have_many(:passive_relationships).with_foreign_key "followed_id"}
    it {expect(user).to have_many(:passive_relationships).dependent :destroy}
  end

  describe "Associations following" do
    it do
      expect(user).to have_many(:following).
                        through(:active_relationships).
                        source :followed
    end
  end

  describe "Associations followers" do
    it do
      expect(user).to have_many(:followers).
                        through(:passive_relationships).
                        source :follower
    end
  end

  describe "scope search_by" do
    before{
      @rooney = FactoryGirl.create(:user, name: "Roonney", email: "rooney@gmail.com")
      @nany = FactoryGirl.create(:user, name: "Nany", email: "nany@gmail.com")
      @persie = FactoryGirl.create(:user, name: "Van Persie", email: "persie@gmail.com")
    }  
    it {expect(User.search_by "y").to eq [@rooney, @nany]}
    it {expect(User.search_by "n").to include @persie}
  end

  describe "#is_admin?" do
    let(:admin) {FactoryGirl.build :admin}
    it {expect(admin).to be_is_admin}
  end

  describe "#is_user?" do
    it {expect(user.is_user? user).to eq true}
  end

  describe "following? and follow/unfollow another user" do
    before do
      @rojo = FactoryGirl.create :user, email: "rojo@gmail.com", name: "Rojo"
      @smalling = FactoryGirl.create :user, id: 12, email: "smalling@gmail.com", name: "Chris Smalling"
      @jones = FactoryGirl.create :user, id: 4, email: "jones@gmail.com", name: "Phil Jones"    
      user.follow @smalling
      user.follow @jones
    end
    it {expect(user.following_ids).to eq [4, 12]}
    it {expect(user).to be_following @smalling}
    it {expect {user.follow @rojo}.to change(Relationship, :count).by 1}
    it {expect {user.follow @rojo}.to change(Activity, :count).by 1}
    it {expect {user.unfollow @smalling}.to change(Relationship, :count).by -1}
    it {expect {user.unfollow @smalling}.to change(Activity, :count).by 1}
  end

  describe "to_param" do
    before {@another_user = FactoryGirl.create :user, id: 3, email: "tribeo@gmail.com", name: "Tri Beo"}
    it {expect(@another_user.to_param).to eq "3-tri-beo"}
  end

  describe "favorite? book" do
    before do
      @book = FactoryGirl.build :book, id: 1
      @favorite = FactoryGirl.create :favorite, book_id: 1, user: user
    end
    it {expect(user).to be_favorite @book}
  end

  describe "create activity" do
    before do
      @mata = FactoryGirl.create :user, id: 8, email: "mata@gmail.com", name: "Juan Mata"
      @book = FactoryGirl.create :book, id: 1
      @review = FactoryGirl.create :review, id: 1
      @request = FactoryGirl.create :request, id: 1, user: user
      @comment = FactoryGirl.create :comment, id: 1, user: user, review: @review
    end
    it {expect {user.create_activity(@mata.id, "follow")}.to change(Activity, :count).by 1}
    it {expect {user.create_activity(@mata.id, "unfollow")}.to change(Activity, :count).by 1}
    it {expect {user.create_activity(@review.id, "review")}.to change(Activity, :count).by 1}
    it {expect {user.create_activity(@book.id, "reading")}.to change(Activity, :count).by 1}
    it {expect {user.create_activity(@book.id, "read")}.to change(Activity, :count).by 1}
    it {expect {user.create_activity(@book.id, "favorite")}.to change(Activity, :count).by 1}
    it {expect {user.create_activity(@book.id, "unfavorite")}.to change(Activity, :count).by 1}
    it {expect {user.create_activity(@request.id, "request")}.to change(Activity, :count).by 1}
    it {expect {user.create_activity(@comment.id, "comment")}.to change(Activity, :count).by 1}
  end
end
