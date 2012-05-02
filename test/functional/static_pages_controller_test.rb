require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get help" do
    get :help
    assert_response :success
  end

  test "should get initial_capitalization" do
    get :initial_capitalization
    assert_response :success
  end

end
