class RenameShapesTypeToSpType < ActiveRecord::Migration[5.2]
  def change
  	rename_column(:shapes, :type, :sp_type)
  end
end
