class Shape < ApplicationRecord

	has_many :graphics
	
	#attr_reader(:shape_id, :shape_name, :color_code, :user_name, :last_updated_at)

	class << self

		def shapes
	  		arel_table
		end

		def fetch_graphics_colors_users(limit, skip)
			find_by_sql(shapes_graphics_sql(limit, skip))
		end

		def shapes_graphics_sql(limit, skip)
			shapes_graphics(limit, skip).to_sql.gsub('"', "")
		end

		def shapes_graphics(limit, skip)
			shapes.join(graphics_colors_users, Arel::Nodes::OuterJoin).on(shapes[:id].eq(graphics_colors_users[:grp_shape_id])).project(shapes_select).take(limit).skip(skip)
		end

		def shapes_select
			[shapes[:id].as("shape_id"), shapes[:name].as("shape_name"), graphics_colors_users[:color_code].as("color_code"), graphics_colors_users[:user_name].as("user_name"), graphics_colors_users[:last_updated_at].as("last_updated_at")]
		end

		def graphics_colors_users
			graphics.join(colors).on(graphics[:color_id].eq(colors[:id])).join(users).on(graphics[:user_id].eq(users[:id])).group(graphics[:shape_id]).project(graphics_select).as(graphics_desire_table)
		end

		def graphics_select
			[graphics[:shape_id].as("grp_shape_id"), colors[:code].as("color_code"), users[:name].as("user_name"), graphics[:updated_at].maximum.as("last_updated_at")]
		end

		def graphics_desire_table
			"graphics_colors_users"
		end

		def graphics
			Graphic.arel_table
		end

		def colors
			Color.arel_table
		end

		def users
			User.arel_table
		end

	end
end
