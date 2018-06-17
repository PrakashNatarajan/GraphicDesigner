require 'rails_helper'

RSpec.describe Graphic, :type => :model do
  
  let!(:color) {Color.create({ name: "Red", code: "#FF0000" })}
  let!(:shape) {Shape.create({ name: "Square_name", sp_type: "SQUARE" })}
  let!(:user) {User.create({name: "User_name", phone: nil, email: "User_7@graphics.com"})}

  context "create_or_update" do
  	
    it "is valid with valid attributes" do
      graphic = Graphic.create_or_update({color_id: color.id, shape_id: shape.id, user_id: user.id})
      expect(graphic.save).to eq(true)
    end
    it "is not valid without a color_id" do
      graphic = Graphic.create_or_update({shape_id: shape.id, user_id: user.id})
  	  expect(graphic).to_not be_valid
    end
    it "is not valid without a shape_id" do
      graphic = Graphic.create_or_update({color_id: color.id, user_id: user.id})
  	  expect(graphic).to_not be_valid
    end
    it "is not valid without a user_id" do
      graphic = Graphic.create_or_update({color_id: color.id, shape_id: shape.id})
  	  expect(graphic).to_not be_valid
    end

  end
end