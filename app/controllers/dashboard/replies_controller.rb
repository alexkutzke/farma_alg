class Dashboard::RepliesController < ApplicationController
  layout "dashboard"

  before_filter :authenticate_user!
  before_filter :get_message
  before_filter :can_post, :only => [:create]
  before_filter :can_delete, :only => [:delete]

  def get_message
    @message = Message.find(params[:message_id])
  end

  def can_post
    if (not @message.user_id == current_user.id) and (not @message.target_user_ids.include?(current_user.id.to_s))
      render :file => "public/401.html", :status => :unauthorized
    end
  end

  def can_delete
    if (not @message.user_id == current_user.id)
      render :file => "public/401.html", :status => :unauthorized
    end
  end

  def create

    @reply = Reply.new(params[:reply])

    @reply.user_id = current_user.id
    @reply.message_id = @message.id

    respond_to do |format|
      if @reply.save
        @message.new_flag_user_ids = @message.target_user_ids
        @message.save!
        format.html { redirect_to dashboard_message_path(@message), notice: 'Mensagem criada com sucesso.' }
        format.json { render json: @reply, status: :created, location: @message }
      else
        format.html { render "dashboard/messages/show" }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reply = Reply.find(params[:id])
    @reply.destroy

    respond_to do |format|
      format.html { redirect_to dashboard_message_path(@message) }
      format.json { head :no_content }
    end
  end

end