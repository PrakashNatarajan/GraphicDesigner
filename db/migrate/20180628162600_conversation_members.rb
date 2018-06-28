class ConversationMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :conversation_members do |t|
      t.references :conversation, foreign_key: true
      t.references :member, foreign_key: true
      t.timestamps
    end
    remove_column(:conversation_members, :id)
  end
end
