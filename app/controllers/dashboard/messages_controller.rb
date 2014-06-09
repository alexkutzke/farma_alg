class Dashboard::MessagesController < ApplicationController
  layout "dashboard"

  before_filter :authenticate_user!
  before_filter :verify_admin, :except => [:index,:show]

  def verify_admin
    unless current_user.admin?
      render :file => "public/401.html", :status => :unauthorized
    end
  end

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


  def new
    init_search
    get_available_users
    @message = Message.new(params[:message])
  end

  def create

    @message = Message.new(params[:message])

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

    respond_to do |format|
      if @message.save
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

end