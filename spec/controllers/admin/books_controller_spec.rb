require 'rails_helper'

RSpec.describe Admin::BooksController, type: :controller do
  let(:admin) {FactoryGirl.create :admin}
  let(:user) {FactoryGirl.create :user}

  before {sign_in admin}

  shared_examples_for "account not sign in" do |method, action|
    before do
      sign_out admin
      perform_action
    end
    it {expect(response).to redirect_to new_user_session_path}
    it {expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."}
  end

  shared_examples "account signed in user" do |method, action|
    before do
      sign_out admin
      sign_in user
      perform_action
    end
    it {expect(response).to redirect_to root_path}
    it {expect(flash[:error]).to eq "You are not authorized to view that page."}
  end

  describe "GET #index" do
    context "when not sign in" do
      it_should_behave_like "account not sign in" do
        let(:perform_action) {get :index}
      end
    end

    context "when signed in user" do
      it_should_behave_like "account signed in user" do
        let(:perform_action) {get :index}
      end
    end

    context "when signed in admin" do
      let(:books) {FactoryGirl.create_list :many_books, 2}
      before {get :index}
      it {expect(response).to render_template :index}
      it {expect(assigns :books).to eq books}
    end
  end

  describe "GET #new" do
    context "when not sign in" do
      it_should_behave_like "account not sign in" do
        let(:perform_action) {get :new}
      end
    end

    context "when signed in user" do
      it_should_behave_like "account signed in user" do
        let(:perform_action) {get :new}
      end
    end

    context "when signed in admin" do
      before {get :new}
      it {expect(response).to render_template :new}
    end
  end

  describe "POST #create" do
    context "when signed in admin" do
      let(:category) {FactoryGirl.build :category, id: 1}
      context "when the book saves successfully" do
        it do
          expect{
            post :create, book: {title: "Book 1", author: "tribeo",
                                publish_date: "2015-06-12", number_of_pages: 100,
                                category_id: category.id}
            FactoryGirl.create :book
          }.to change(Book, :count).by 1
        end
      end

      # context "when the book saves failure" do
      #   let(:book) {mock_model Book}
      #   before do
      #     Book.stub(:new).and_return book
      #     book.stub(:save).and_return false
      #   end

      #   it do
      #     expect{
      #       FactoryGirl.create :book
      #     }.not_to change(Book, :count)
      #   end

        # it do
        #   book = mock_model Book
        #   book. should be_a(Book)
        # end
      # end
    end

    context "when not sign in" do
      it_should_behave_like "account not sign in" do
        let(:perform_action) {post :create}
      end
    end

    context "when signed in user" do
      it_should_behave_like "account signed in user" do
        let(:perform_action) {post :create}
      end
    end
  end

  # describe "mock_model(Book) with no Book constant in existence" do
    # let(:book_mock) {mock_model Book}

    # it "is valid by default" do
    #   expect(book_mock).to be_valid
    # end

    # before do
    #   Book.stub(:new).and_return book_mock
    #   book_mock.stub(:save).and_return false
    # end
    # it "generates a constant" do
    #   expect(Object.const_defined?(:Book)).to eq be_true
    #   mock_model("Book")
    #   expect(Object.const_defined?(:Book)).to be_true
    # end

    # describe "generates an object that ..." do
    #   it "returns the correct name" do
    #     book = mock_model("Book")
    #     expect {book.class.name}.to eq ("Book")
    #   end

    #   it "says it is a book" do
    #     book = mock_model ("Book")
    #     expect {book}.to be_a ("Book")
    #   end
    # end
  # end
end
