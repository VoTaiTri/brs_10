require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let!(:user) {FactoryGirl.create :user}

  describe "GET #index" do
    let(:books) {FactoryGirl.create_list :many_books, 2}
    before {get :index}

    it {expect(response).to render_template :index}
    it {expect(assigns :books).to eq books}
  end

  describe "GET #show" do
    let(:book) {FactoryGirl.create :book}
    let(:reviews) {FactoryGirl.create_list :review, 2, user: user, book: book}
    let(:book_state) {FactoryGirl.build :book_state, user: user, book: book}

    before do
      sign_in user
      get :show, id: book.id
    end

    context "when user not sign in" do
      before do
        sign_out user
        get :show, id: book.id
      end
      
      it {expect(response).to redirect_to new_user_session_path}
      it {expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."}
    end

    context "when user signed in" do
      it {expect(response).to render_template :show}
      it {expect(assigns :book).to eq book}
      it {expect(assigns :reviews).to eq reviews}
      it {expect(assigns :book_state).to eq BookState.find_by book: book, user: user}
    end
  end
end
