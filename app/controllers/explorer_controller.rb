class ExplorerController < ApplicationController
	layout "explorer"
	before_filter :authenticate_user!

	def index
    @users = User.all	
    @teams = Team.all
    @los = Lo.all
    @questions = Question.all
	end

  def load_users
    @users = User.all
  end

  def search
    @as = Answer.search(params)
  end

  def fulltext_search
    @as = Answer.fulltext_search(params[:query])

    render 'search'
  end

  def info_answer
    @answer = Answer.find(params[:id])
    @available_tags = @answer.available_tags
  end

  def info_connection
    @connection = Connection.find(params[:id])
    @answer_a = Answer.find(@connection.answer_id)
    @answer_b = Answer.find(@connection.target_answer_id)
  end

  # ================================================================
  # ================================================================
  # TAGS MANIPULATION
  def add_tag
    tag = Tag.where(:name => params[:query])
    @answer = Answer.find(params[:answer_id])

    if tag.count > 0
      @answer.tags << tag.first
      @answer.rejected_tags.delete(tag.first.id.to_s)
      @answer.save!

      @answer.schedule_process_propagate

      @available_tags = @answer.available_tags
      render :info_answer
    else
      @tag = Tag.new
      @tag.name = params[:query]
      render :new_tag
    end
  end

  def create_tag
    @tag = Tag.new(params[:tag])

    if @tag.save
      @answer = Answer.find(params[:answer_id])
      @answer.tags << @tag
      @answer.save!

      @answer.schedule_process_propagate

      @available_tags = @answer.available_tags
      @notice = "Tag #{@tag.name} criada com sucesso!"
    end

    render :info_answer
  end

  def remove_tag
    @answer = Answer.find(params[:answer_id])
    @answer.tags.delete(Tag.find(params[:id]))
    @answer.rejected_tags << params[:id]
    @answer.save!

    @answer.schedule_process_propagate
    @available_tags = @answer.available_tags

    render :info_answer
  end

  def accept_tag
    @answer = Answer.find(params[:answer_id])
    @tag = Tag.find(params[:id])

    @answer.tags << @tag

    i = @answer.automatically_assigned_tags.index{ |x| x[0].to_s == @tag.id.to_s }
    @answer.automatically_assigned_tags.delete_at(i)
    @answer.save!
    render :info_answer
  end

  def reject_tag
    @answer = Answer.find(params[:answer_id])

    @tag = Tag.find(params[:id])

    i = @answer.automatically_assigned_tags.index{ |x| x[0].to_s == @tag.id.to_s }
    @answer.automatically_assigned_tags.delete_at(i)
    @answer.rejected_tags << @tag.id.to_s
    @answer.save!    
    render :info_answer
  end
  # ================================================================
  # ================================================================
end