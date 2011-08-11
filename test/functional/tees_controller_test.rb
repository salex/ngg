require 'test_helper'

class TeesControllerTest < ActionController::TestCase
  setup do
    @tee = tees(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tee" do
    assert_difference('Tee.count') do
      post :create, tee: @tee.attributes
    end

    assert_redirected_to tee_path(assigns(:tee))
  end

  test "should show tee" do
    get :show, id: @tee.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tee.to_param
    assert_response :success
  end

  test "should update tee" do
    put :update, id: @tee.to_param, tee: @tee.attributes
    assert_redirected_to tee_path(assigns(:tee))
  end

  test "should destroy tee" do
    assert_difference('Tee.count', -1) do
      delete :destroy, id: @tee.to_param
    end

    assert_redirected_to tees_path
  end
end
