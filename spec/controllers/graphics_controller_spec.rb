require 'rails_helper'
require 'spec_helper'

RSpec.describe GraphicsController, :type => :controller do
  
  before do
    @graphics = Graphic.all
  end

  it "should get index" do
    get graphics_path
    expect(response.status).to eq(200)
  end

end