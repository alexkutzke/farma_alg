class DashboardController < ApplicationController
	layout "dashboard"

  before_filter :authenticate_user!
  before_filter :verify_admin, :only =>[:graph,:graph_search,:graph_answer_info,:graph_search_result,:graph_connection_info,:graph_add_tag,:graph_new_tag,:graph_create_tag]

  def verify_admin
    unless current_user.admin?
      redirect_to root_url
    end
  end

  def init_search
    @teams = current_user.all_teams
    @questions = current_user.all_questions
    @los = current_user.all_los
    @users = current_user.all_students
    @tags = current_user.all_tags
  end

	def home
	end

  def timeline
    init_search
  end

  def timeline_search
    @as = Answer.search(params)

    render 'timeline_search_result'
  end

  def search
    init_search
  end

  def fulltext_search
    @as = Answer.search(params,current_user)

    render 'search_result'
  end
  
  def graph
    init_search
  end

  def graph_search
    @as = Answer.search(params,current_user)
    
    render 'graph_search_result'
  end

  def graph_answer_info
    @answer = Answer.find(params[:id])
    @available_tags = @answer.available_tags
  end

  def graph_connection_info
    @connection = Connection.find(params[:id])
    @answer1 = Answer.find(@connection.answer_id)
    @answer2 = Answer.find(@connection.target_answer_id)
  end

  # ================================================================
  # ================================================================
  # TAGS MANIPULATION
  def graph_add_tag
    tag = Tag.where(:name => params[:query])
    @answer = Answer.find(params[:answer_id])

    if tag.count > 0
      @answer.tags << tag.first
      @answer.rejected_tags.delete(tag.first.id.to_s)
      @answer.save!

      @answer.schedule_process_propagate

      @available_tags = @answer.available_tags
      render :graph_answer_info
    else
      @tag = Tag.new
      @tag.name = params[:query]
      render :graph_new_tag
    end
  end

  def graph_create_tag
    @tag = Tag.new(params[:tag])

    if @tag.save
      @answer = Answer.find(params[:answer_id])
      @answer.tags << @tag
      @answer.save!

      @answer.schedule_process_propagate

      @available_tags = @answer.available_tags
      @notice = "Tag #{@tag.name} criada com sucesso!"
    end

    render :graph_answer_info
  end

  def graph_remove_tag
    @answer = Answer.find(params[:answer_id])
    @answer.tags.delete(Tag.find(params[:id]))
    @answer.rejected_tags << params[:id]
    @answer.save!

    @answer.schedule_process_propagate
    @available_tags = @answer.available_tags

    render :graph_answer_info
  end

  def graph_accept_tag
    @answer = Answer.find(params[:answer_id])
    @tag = Tag.find(params[:id])

    @answer.tags << @tag

    i = @answer.automatically_assigned_tags.index{ |x| x[0].to_s == @tag.id.to_s }
    @answer.automatically_assigned_tags.delete_at(i)
    @answer.save!
    render :graph_answer_info
  end

  def graph_reject_tag
    @answer = Answer.find(params[:answer_id])

    @tag = Tag.find(params[:id])

    i = @answer.automatically_assigned_tags.index{ |x| x[0].to_s == @tag.id.to_s }
    @answer.automatically_assigned_tags.delete_at(i)
    @answer.rejected_tags << @tag.id.to_s
    @answer.save!    
    render :graph_answer_info
  end
  # ================================================================
  # ================================================================
end