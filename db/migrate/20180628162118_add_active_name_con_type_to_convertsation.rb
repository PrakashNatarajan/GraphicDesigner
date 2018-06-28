class AddActiveNameConTypeToConvertsation < ActiveRecord::Migration[5.2]
  def change
  	add_column(:conversations, :active, :boolean)
  	add_column(:conversations, :contype, :string)
  	add_column(:conversations, :name, :string)
  	add_index(:conversations, [:contype, :recipient_id, :sender_id], unique: true)
  	add_index(:conversations, [:contype, :name, :sender_id], unique: true)
  end
end
