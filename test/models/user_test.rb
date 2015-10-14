require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup 
    @user = User.new(name: "User",email: "user@example.com")
  end

  test 'user should be valid' do 
    assert @user.valid?
  end

  test 'user name should be valid' do 
    @user.name = "  "
    assert_not @user.valid?
  end

  test 'user email should not be valid' do
    @user.email = "  "
  end


end
