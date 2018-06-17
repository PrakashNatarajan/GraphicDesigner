require 'rails_helper'

RSpec.describe GraphicsController, :type => :controller do
  
  before do
    @graphics = Graphic.all
  end

  context "create_or_update" do
  	
    it "is valid with valid attributes" do
      graphic = Graphic.create_or_update({color_id: color_id, shape_id: shape_id, user_id: user_id})
  	  graphic.save
      expect(Graphic.first).to be_valid
    end
    it "is not valid without a color_id" do
      graphic = Graphic.create_or_update({shape_id: shape_id, user_id: user_id})
  	  expect(graphic).to_not be_valid
    end
    it "is not valid without a shape_id" do
      graphic = Graphic.create_or_update({color_id: color_id, user_id: user_id})
  	  expect(graphic).to_not be_valid
    end
    it "is not valid without a user_id" do
      graphic = Graphic.create_or_update({color_id: color_id, shape_id: shape_id})
  	  expect(graphic).to_not be_valid
    end

  end
end