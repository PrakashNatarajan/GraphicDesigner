class Message < ApplicationRecord
  belongs_to :member
  belongs_to :conversation
end
