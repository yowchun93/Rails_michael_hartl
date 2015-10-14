require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup 
    @user = User.new(name: "User",email: "user@example.com")
  end

  # @user = User.create(name: "User",email: "user@example.com")

  test 'user should be valid' do 
    assert @user.valid?
  end

  test 'user name should be valid' do 
    @user.name = "  "
    assert_not @user.valid?
  end

  test 'user email should not be valid' do
    @user.email = "  "
    assert_not @user.valid?
  end

  test 'user name should not be too long' do 
    @user.name = 'a' * 250
    assert_not @user.valid?
  end

  test 'user email should not be too long' do 
    @user.email = 'a' * 250 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid address' do 
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        firs.last@foo.jp alice+bob@baz.cn ]
    valid_addresses.each do |valid_address| 
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid "
    end
  end

  test 'email address should be unique' do 
    duplicate_user = @user.dup 
    duplicate_user.email = @user.email
    @user.save 
    assert_not duplicate_user.valid?
  end


end
