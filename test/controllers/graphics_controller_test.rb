require 'test_helper'

class GraphicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @graphic = graphics(:one)
  end

  test "should get index" do
    get graphics_url
    assert_response :success
  end

  test "should get new" do
    get new_graphic_url
    assert_response :success
  end

  test "should create graphic" do
    assert_difference('Graphic.count') do
      post graphics_url, params: { graphic: { color_id: @graphic.color_id, shape_id: @graphic.shape_id, user_id: @graphic.user_id } }
    end

    assert_redirected_to graphic_url(Graphic.last)
  end

  test "should show graphic" do
    get graphic_url(@graphic)
    assert_response :success
  end

  test "should get edit" do
    get edit_graphic_url(@graphic)
    assert_response :success
  end

  test "should update graphic" do
    patch graphic_url(@graphic), params: { graphic: { color_id: @graphic.color_id, shape_id: @graphic.shape_id, user_id: @graphic.user_id } }
    assert_redirected_to graphic_url(@graphic)
  end

  test "should destroy graphic" do
    assert_difference('Graphic.count', -1) do
      delete graphic_url(@graphic)
    end

    assert_redirected_to graphics_url
  end
end
