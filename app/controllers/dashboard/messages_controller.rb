class Dashboard::MessagesController < ApplicationController
  layout "dashboard"

  before_filter :authenticate_user!
  before_filter :verify_prof, :except => [:index,:show]

  def get_available_users
    @available_users = []
    @users.each do |u|
      a = Hash.new
      a[:label] = u.name
      a[:value] = [u.id.to_s,"user_id"]
      @available_users << a
    end

    @teams.each do |t|
      a = Hash.new
      a[:label] = "Turma: " + t.name
      a[:value] = [t.id.to_s,"team_id"]
      @available_users << a
    end
  end

  def init_search
    @teams = current_user.all_teams
    @questions = current_user.all_questions
    @los = current_user.all_los
    @users = current_user.all_students
    @tags = current_user.all_tags
  end

  def index
    @messages = User.find(current_user.id).messages.desc(:updated_at)

	@messages_to_me = Message.any_of({:target_user_ids => current_user.id}, {:user_ids => current_user.id.to_s}).desc(:updated_at)

#    @messages_to_me = Message.where(:target_user_ids => current_user.id).desc(:updated_at)
  end

  def show
    @message = Message.find(params[:id])
    Log.log_message_view(current_user.id,@message.id)
    @message.new_flag_user_ids.delete(current_user.id)
    if current_user.id == @message.user.id
      @message.new_flag_user_id = false
    end
    @message.save!
    @reply = Reply.new
    get_messages
  end

  def new
    init_search
    get_available_users
    @method = :post
    @path = "/dashboard/messages"
    @message = Message.new(params[:message])

    if params.has_key?(:recom)
      Log.log_recommendation_click(current_user.id,params[:message])
    end
  end

  def edit
    init_search
    get_available_users
    @message = Message.find(params[:id])
    @path = "/dashboard/messages/"+params[:id]
    @method = :put
    render "new"
  end

  def create

    @message = Message.new(params[:message])

    @message.user_id = current_user.id
    @message.target_user_ids = []

    unless params[:message].nil?
      if params[:message].has_key?(:user_ids)
        @message.target_user_ids = params[:message][:user_ids]
      end
      if params[:message].has_key?(:team_ids)
        params[:message][:team_ids].each do |team_id|
          team = Team.find(team_id)
          @message.target_user_ids = @message.target_user_ids + team.user_ids
        end
      end
    end

    @message.new_flag_user_ids = @message.target_user_ids

    respond_to do |format|
      if @message.save
        if @message.has_recommendation?
          Log.log_message_sent_with_recommendation(current_user.id,@message.id)
        else
          Log.log_message_sent(current_user.id,@message.id)
        end

        format.html { redirect_to dashboard_messages_path, notice: 'Mensagem criada com sucesso.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        init_search
        get_available_users
        format.html { render action: "new" }
        format.json { render json: @messages.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @message = Message.find(params[:id])

    @message.user_id = current_user.id

    unless params[:message].nil?
      if params[:message].has_key?(:user_ids)
        @message.target_user_ids = params[:message][:user_ids]
      end
      if params[:message].has_key?(:team_ids)
        params[:message][:team_ids].each do |team_id|
          team = Team.find(team_id)
          @message.target_user_ids = @message.target_user_ids + team.user_ids
        end
      end
    end

    @message.new_flag_user_ids = @message.target_user_ids

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { redirect_to dashboard_message_path(@message), notice: 'Mensagem atualizada!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to "/dashboard/messages" }
      format.json { head :no_content }
    end
  end

end
