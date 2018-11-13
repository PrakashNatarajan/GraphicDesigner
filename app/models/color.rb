class Color < ApplicationRecord

    validates(:name, :code, presence: true)
    validates(:name, :code, uniqueness: true)

	has_many :graphics

	def colors_table
	  arel_table
	end
	
end
