require 'test_helper'

class UserSignupTestTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid sign in rejected" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { email: "benmuschol@gmail.com",
                               password: "password",
                               password_confirmation: "password" }
    end
    assert_template 'users/new'
  end

  test "valid sign up accepted with activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: { email: "muschol.b@husky.neu.edu",
                               password:              "password",
                               password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
  end
end
