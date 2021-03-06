class Graphic < ApplicationRecord

	belongs_to :color
	belongs_to :shape
	belongs_to :user

	validates :color_id, :shape_id, :user_id, presence: true

	delegate :code, to: :color, prefix: true
	delegate :name, to: :shape, prefix: true
	delegate :name, to: :user, prefix: true

	def self.create_or_update(args = {})
		graphic = Graphic.where(shape_id: args[:shape_id], user_id: args[:user_id]).first_or_initialize
		graphic.color_id = args[:color_id]
		graphic
    end
    

    def graphics_table
	  arel_table
	end

end
