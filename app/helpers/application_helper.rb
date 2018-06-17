module ApplicationHelper

	def current_user
	  session[:user]
	end

	def get_color_code(shape)
	  color_code = if not shape.graphics.empty?
	  	shape.graphics.last.color_code
	  else
	  	"tomato"
	  end
	  color_code
	end

	def get_updated_at(shape)
	  updated_at = if not shape.graphics.empty?
	  	shape.graphics.last.updated_at
	  else
	  	""
	  end
	  updated_at
	end

	def get_user_name(shape)
	  user_name = if not shape.graphics.empty?
	  	shape.graphics.last.user_name
	  else
	  	""
	  end
	  user_name
	end
	
end
