require "application_system_test_case"

class ShapesTest < ApplicationSystemTestCase
  setup do
    @shape = shapes(:one)
  end

  test "visiting the index" do
    visit shapes_url
    assert_selector "h1", text: "Shapes"
  end

  test "creating a Shape" do
    visit shapes_url
    click_on "New Shape"

    fill_in "Name", with: @shape.name
    fill_in "Type", with: @shape.type
    click_on "Create Shape"

    assert_text "Shape was successfully created"
    click_on "Back"
  end

  test "updating a Shape" do
    visit shapes_url
    click_on "Edit", match: :first

    fill_in "Name", with: @shape.name
    fill_in "Type", with: @shape.type
    click_on "Update Shape"

    assert_text "Shape was successfully updated"
    click_on "Back"
  end

  test "destroying a Shape" do
    visit shapes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shape was successfully destroyed"
  end
end
