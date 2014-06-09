class Dashboard::TagsController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :verify_admin

  def verify_admin
    unless current_user.admin?
      render :file => "public/401.html", :status => :unauthorized
    end
  end
  
  # ================================================================
  # ================================================================
  # TAGS MANIPULATION
  def show
    @answer = Answer.find(params[:answer_id])
    @available_tags = @answer.available_tags
  end

  def add_tag
    tag = Tag.where(:name => params[:query])
    @answer = Answer.find(params[:answer_id])

    if tag.count > 0
      @answer.tag_ids << tag.first.id.to_s
      @answer.rejected_tags.delete(tag.first.id.to_s)
      @answer.save!

      @answer.schedule_process_propagate

      @available_tags = @answer.available_tags
      render :show  
    else
      @tag = Tag.new
      @tag.name = params[:query]
      render :new
    end
  end

  def create_tag
    @tag = Tag.new(params[:tag])

    if @tag.save
      @answer = Answer.find(params[:answer_id])
      @answer.tag_ids << @tag.id.to_s
      @answer.save!

      @answer.schedule_process_propagate

      @available_tags = @answer.available_tags
      @notice = "Tag #{@tag.name} criada com sucesso!"
    end

    render :show
  end

  def remove_tag
    @answer = Answer.find(params[:answer_id])
    @answer.tag_ids.delete(params[:id])
    @answer.rejected_tags << params[:id]
    @answer.save!

    @answer.schedule_process_propagate
    @available_tags = @answer.available_tags

    render :show
  end

  def accept_tag
    @answer = Answer.find(params[:answer_id])
    @tag = Tag.find(params[:id])

    @answer.tag_ids << @tag.id.to_s

    i = @answer.automatically_assigned_tags.index{ |x| x[0].to_s == @tag.id.to_s }
    @answer.automatically_assigned_tags.delete_at(i)
    @answer.save!
    @available_tags = @answer.available_tags
    render :show
  end

  def reject_tag
    @answer = Answer.find(params[:answer_id])

    @tag = Tag.find(params[:id])

    i = @answer.automatically_assigned_tags.index{ |x| x[0].to_s == @tag.id.to_s }
    @answer.automatically_assigned_tags.delete_at(i)
    @answer.rejected_tags << @tag.id.to_s
    @answer.save!    
    @available_tags = @answer.available_tags
    render :show
  end
  # ================================================================
  # ================================================================

end