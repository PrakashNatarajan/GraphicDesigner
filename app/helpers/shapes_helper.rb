module ShapesHelper

	def get_color_code(shape)
	  color_code = if not shape.color_code.nil?
	  	shape.color_code
	  else
	  	"tomato"
	  end
	  color_code
	end

	def get_updated_at(shape)
	  updated_at = if not shape.last_updated_at.nil?
	  	shape.last_updated_at
	  else
	  	""
	  end
	  updated_at
	end

	def get_user_name(shape)
	  user_name = if not shape.user_name.nil?
	  	shape.user_name
	  else
	  	""
	  end
	  user_name
	end

	def shape_tool_tip(user_name, updated_at)
		"#{user_name} at #{updated_at}".strip
	end

end
