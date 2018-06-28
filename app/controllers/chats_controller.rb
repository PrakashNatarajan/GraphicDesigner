class ChatsController < ApplicationController

  def index
  	session[:conversations] ||= []

    @members = Member.all.where.not(id: current_member)
    @conversations = Conversation.includes(:recipient, :messages)
                                 .find(session[:conversations])
  end
  
end