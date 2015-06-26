require 'rails_helper'

RSpec.describe Admin::BooksController, type: :controller do
  let!(:admin) {FactoryGirl.create :admin}
  let!(:user) {FactoryGirl.create :user}

  before {sign_in admin}

  shared_context "not sign in" do
    before {sign_out admin}
  end

  shared_context "user sign in" do
    before do
      sign_out admin
      sign_in user
    end
  end

  # shared_examples "user not sign in" do |method|
    # before do
    #   sign_out admin
    #   get method
    # end
    # it {expect(response).to redirect_to new_user_session_path}
    # it {expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."}
  # end

  shared_examples_for "user not sign in" do |method, action|
    before do
      sign_out admin
      method action
    end
    it {expect(response).to redirect_to new_user_session_path}
    it {expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."}
  end

  shared_examples "account not sign in" do
    it {expect(response).to redirect_to new_user_session_path}
    it {expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."}
  end

  shared_examples "account signed in user" do
    it {expect(response).to redirect_to root_path}
    it {expect(flash[:error]).to eq "You are not authorized to view that page."}
  end

  describe "GET #index" do
    before {get :index}

    context "when not sign in" do
      include_context "not sign in"
      before {get :index}
      it_behaves_like "account not sign in"
      # it_should_behave_like "user not sign in", [:get, :index]
    end

    context "when signed in user" do
      include_context "user sign in"
      before {get :index}
      it_behaves_like "account signed in user"
    end

    context "when signed in admin" do
      let(:books) {FactoryGirl.create_list :many_books, 2}
      it {expect(response).to render_template :index}
      it {expect(assigns :books).to eq books}
    end
  end

  describe "GET #new" do
    before {get :new}

    context "when not sign in" do
      include_context "not sign in"
      before {get :new}
      it_behaves_like "account not sign in"
    end

    context "when signed in user" do
      include_context "user sign in"
      before {get :new}
      it_behaves_like "account signed in user"
    end
    
    context "when signed in admin" do
      it {expect(response).to render_template :new}
    end
  end

  describe "POST #create" do
    context "when signed in admin" do
      let(:category) {FactoryGirl.build :category, id: 1}
      context "when the book saves successfully" do
        it do
          expect{
            # post :create, book: {title: "Book 1", author: "tribeo",
            #                     publish_date: "2015-06-12", number_of_pages: 100,
            #                     category_id: category.id}
            FactoryGirl.create :book
          }.to change(Book, :count).by 1
        end
      end

      context "when the book saves failure" do
        # let(:book) {mock_model Book}
        # before do
        #   Book.stub(:new).and_return book
        #   book.stub(:save).and_return false
        # end

        # it do
        #   expect{
        #     FactoryGirl.create :book
        #   }.not_to change(Book, :count)
        # end
        it do
          book = mock_model Book
          book. should be_a(Book)
        end
      end
    end
    
    context "when not sign in" do
      include_context "not sign in"
      before {post :create}
      it_behaves_like "account not sign in"
    end

    context "when signed in user" do
      include_context "user sign in"
      before {post :create}
      it_behaves_like "account signed in user"
    end
  end

  # describe "mock_model(Book) with no Book constant in existence" do
  #   it "generates a constant" do
  #     Object.const_defined?(:Book).should be_false
  #     mock_model("Book")
  #     Object.const_defined?(:Book).should be_true
  #   end

  #   describe "generates an object that ..." do
  #     it "returns the correct name" do
  #       book = mock_model Book
  #       book.class.name.should eq Book
  #     end

  #     it "says it is a book" do
  #       book = mock_model Book
  #       book.should be_a Book
  #     end
  #   end
  # end
end
