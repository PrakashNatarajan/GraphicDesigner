class CreateGraphics < ActiveRecord::Migration[5.2]
  def change
    create_table :graphics do |t|
      t.integer :shape_id
      t.integer :user_id
      t.integer :color_id

      t.timestamps
    end
  end
end
