require 'test_helper'

class UserSignupTestTest < ActionDispatch::IntegrationTest

  test "invalid sign in rejected" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { email: "benmuschol@gmail.com",
                               password: "password",
                               password_confirmation: "password" }
    end
    assert_template 'users/new'
  end

  test "valid sign up accepted" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { email: "muschol.b@husky.neu.edu",
                                            password: "password",
                                            password_confirmation: "password" }
    end
    assert_template 'static_pages/index'
  end
end
