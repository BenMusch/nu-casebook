require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(email: "muschol.b@husky.neu.edu",
                     password: "password",
                     password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = " " * 10
    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation =  " " * 8
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 300
    assert_not @user.valid?
  end

  test "email should not be a duplicate" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should not be too short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "should accept valid emails" do
    valid_emails = %w[muschol.b@husky.neu.edu smith.will@husky.neu.edu
                      AbC.dEF@husky.neu.edu]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test "should reject invalid emails" do
    invalid_emails = %w[muschol@husky.neu.edu muschol.b@husky.edu
                        benmuschol@gmail.com ab.cd.def@husky.neu.edu
                        ab..def@husky.neu.edu ab.def@husky.neu..edu]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end

  test "authenticated should return false with a nil digest" do
    assert_not @user.authenticated?('remember', ' ')
  end
end
