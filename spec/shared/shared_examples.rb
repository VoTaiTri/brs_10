RSpec.shared_examples "user not sign in" do |method|
  let!(:admin) {FactoryGirl.create :admin}
  let!(:user) {FactoryGirl.create :user}
  
  before do
    sign_out admin
    get method
  end
  it {expect(response).to redirect_to new_user_session_path}
  it {expect(flash[:alert]).to eq "You need to sign in or sign up before continuing."}
end