class Conversation < ApplicationRecord
  
  CONTYPES = ["OneToOne", "OneToMany"]
  DEFAULTMEMBERIDS = [1] ##This is for group

  ##Associations
  has_many :messages, dependent: :destroy
  belongs_to :sender, foreign_key: :sender_id, class_name: "Member"
  belongs_to :recipient, foreign_key: :recipient_id, class_name: "Member"

  ##Validations
  #validates :sender_id, :contype, uniqueness: { scope: :recipient_id }
  validate :unique_conversation, on: :create

  scope :fetch_sender_recipient, lambda { |contype, sender_id, recipient_id, name| where(active: true, contype: contype, name: name, sender_id: sender_id, recipient_id: recipient_id)}
  scope :fetch_recipient_sender, lambda { |contype, sender_id, recipient_id, name| where(active: true, contype: contype, name: name, sender_id: recipient_id, recipient_id: sender_id)}

  scope :between_type_members, -> (contype, sender_id, recipient_id, name) do
    fetch_sender_recipient(contype, sender_id, recipient_id, name).or(fetch_recipient_sender(contype, sender_id, recipient_id, name))
  end
  
  def self.get(contype:, sender_id:, recipient_id:, conname: nil)
    conversation = between_type_members(sender_id, recipient_id).first
    return conversation if conversation.present?
    conname = build_name(sender_id, recipient_id) if conname.nil? 
    create(contype: contype, sender_id: sender_id, recipient_id: recipient_id, name: conname, active: true)
  end
  
  def opposed_member(member)
    member == recipient ? sender : recipient
  end

  def self.build_name(sender_id, recipient_id)
    [sender_id, recipient_id].compact.map(&:to_i).sort.join("_")
  end

  ##CustomeValidation
  def unique_conversation
    conversation = self.class.between_type_members(contype, sender_id, recipient_id, name)
    errors.add(:name, "is already exist") if not conversation.blank?
  end

end
