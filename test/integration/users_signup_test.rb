require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'invalid signup ' do
    get signup_path 
    assert_no_difference 'User.count' do 
      post users_path, user: {name: "",
                             email: "user@invalid.com",
                             password: "foo",
                             password_confirmation: "bar"}

    end
    assert_template 'users/new'
  end

  test 'valid signup information' do 
    get signup_path 
    assert_difference 'User.count', 1 do 
      post_via_redirect users_path, user: {name: "ben",
                                     email: "ben@example.com",
                                     password: "foobar",
                                     password_confirmation: "foobar"}
    end
    assert_template 'users/show'
    assert is_logged_in?
  end

end
