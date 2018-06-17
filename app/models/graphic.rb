class Graphic < ApplicationRecord

	belongs_to :color
	belongs_to :shape
	belongs_to :user

	delegate :code, to: :color, prefix: true

	def self.create_or_update(shape_id: shape_id, user_id: user_id, color_id: color_id)
		graphic = Graphic.where(shape_id: shape_id, user_id: user_id).first_or_initialize
		graphic.color_id = color_id
		graphic.save
    end
end
