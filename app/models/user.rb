class User < ApplicationRecord

	has_many :graphics

	def self.create_random_user
	  user = new(name: "User_#{}", email: "")
	  user.name = current_name
	  user.email = current_email
	  user
	end

	def self.current_name
	  "User_#{last.id + 1}"
	end

	def self.current_email
	  "#{current_name}@graphics.com"
	end


	def users_table
	  arel_table
	end

end
