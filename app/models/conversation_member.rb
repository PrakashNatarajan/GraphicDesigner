class ConversationMember < ApplicationRecord
  
  ##Associations
  belongs_to :conversation
  belongs_to :member

  ##Validations
  validates(:conversation_id, :member_id, uniqueness: true)

  

end