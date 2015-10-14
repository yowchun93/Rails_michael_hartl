require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # make sure there are users in the database 
  def setup
    @user = users(:michael)
  end

  test 'login with invalid information' do
    get login_path 
    assert_template 'sessions/new'
    post login_path, session: {email: "",password: ""}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path 
    assert flash.empty?
  end
  # 1. Visit the login path
  # 2. post valid information to the session path
  # 3. verify that login link dissapears
  # 4. verify that logout link appears
  # 5. verify that a profile link appears 
  test 'login with valid information' do 
    get login_path
    post login_path, session: {email: @user.email,password: 'password'}
    assert_redirected_to @user 
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test 'login with valid information followed by logout' do
    get login_path
    post login_path, session: {email: @user.email,password: 'password'}
    # make sure is logged in 
    assert is_logged_in?
    assert_redirected_to @user 
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # logout 
    delete logout_path 
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0 
    assert_select "a[href=?]", user_path(@user), count: 0
  end


end
