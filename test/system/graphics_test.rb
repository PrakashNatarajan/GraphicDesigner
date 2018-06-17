require "application_system_test_case"

class GraphicsTest < ApplicationSystemTestCase
  setup do
    @graphic = graphics(:one)
  end

  test "visiting the index" do
    visit graphics_url
    assert_selector "h1", text: "Graphics"
  end

  test "creating a Graphic" do
    visit graphics_url
    click_on "New Graphic"

    fill_in "Color", with: @graphic.color_id
    fill_in "Shape", with: @graphic.shape_id
    fill_in "User", with: @graphic.user_id
    click_on "Create Graphic"

    assert_text "Graphic was successfully created"
    click_on "Back"
  end

  test "updating a Graphic" do
    visit graphics_url
    click_on "Edit", match: :first

    fill_in "Color", with: @graphic.color_id
    fill_in "Shape", with: @graphic.shape_id
    fill_in "User", with: @graphic.user_id
    click_on "Update Graphic"

    assert_text "Graphic was successfully updated"
    click_on "Back"
  end

  test "destroying a Graphic" do
    visit graphics_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Graphic was successfully destroyed"
  end
end
