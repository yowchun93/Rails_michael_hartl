require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup 
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  #chapter 9 edit 
  # make sure redirect when logged in as wrong user 
  test "should redirect edit when not logged in " do 
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do 
    get :edit, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end 

  # chapter 9 make sure redirected when wrong user
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit,id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  # chapter 9 make sure logged_in as correct user 
  test "should redirect update when logged in as wrong user" do 
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do 
    get :index
    assert_redirected_to login_url
  end

  # # Chapter 9 admin destroy
  #failing test 
   test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
   end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

end
