class Color < ApplicationRecord

	has_many :graphics

	def colors_table
	  arel_table
	end
	
end
