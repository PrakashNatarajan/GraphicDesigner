class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]

  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = Conversation.where(contype: "OneToMany", sender_id: current_member.id).order(name: :asc)
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @conversation = Conversation.where(id: params[:id])[0]
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
  end

  # GET /conversations/1/edit
  def edit
    @conversation = Conversation.where(id: params[:id])[0]
  end

  def create
    @conversation = Conversation.between_type_members(contype, current_member.id, member_id, conname).first
    
    if @conversation.blank?
      @conversation = Conversation.create(contype: contype, sender_id: current_member.id, recipient_id: member_id, name: conname, active: true)
    end
=begin
    respond_to do |format|
      format.js
    end
=end
    if @conversation.valid?
      add_to_conversations unless conversated?
      respond_to do |format|
        format.html { redirect_to conversation_path(@conversation), notice: 'conversation was successfully updated.' }
        format.json { render :show, status: :ok, location: @conversation }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /conversations/1
  # PATCH/PUT /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(name: conname)
        format.html { redirect_to @conversation, notice: 'conversation was successfully updated.' }
        format.json { render :show, status: :ok, location: @conversation }
      else
        format.html { render :edit }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation.destroy
    respond_to do |format|
      format.html { redirect_to conversations_url, notice: 'conversation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def close
    @conversation = Conversation.find(params[:id])
 
    session[:conversations].delete(@conversation.id)
 
    respond_to do |format|
      format.js
    end
    
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def add_to_conversations
    session[:conversations] ||= []
    session[:conversations] << @conversation.id
  end

  def conversated?
    session[:conversations].include?(@conversation.id)
  end

  def contype
    params.fetch(:contype, "OneToOne")
  end

  def member_id
    params.fetch(:member_id, 1)
  end

  def conname
    params.fetch(:name, Conversation.build_name(current_member.id, member_id))
  end

end