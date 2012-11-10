class CommentsController < ApplicationController

  before_filter :authenticate_user!

  prepend_before_filter :get_model
  before_filter :get_comment, :only => [:show, :edit, :update, :destroy]
  respond_to :json

  def index
    @comments = @model.comments
    respond_with(@model, @comments)
  end

  def show
    respond_with(@model, @comment)
  end

  def new
    @comment = @model.comments.buid
    respond_with(@model, @comment)
  end


  def edit
    respond_with(@model, @comment)
  end

  def create
    @comment = @model.comments.build(params[:comment])
    @comment.user_id = current_user.id

    if @comment.save
      respond_with(@model, @comment)
    else
      respond_with(@model, @comment, status: 422)
    end
  end

  def update
    if can_destroy?
      if @comment.update_attributes(params[:comment])
        respond_with(@model, @comment)
      else
        respond_with(@model, @comment, status: 422)
      end
    else
      respond_with(@model, @comment, status: 422)
    end
  end

  def destroy
    if can_destroy?
      @comment.destroy
      respond_with(@model, data: @comment)
    else
      render json: {comments: @comment}, status: 405
    end
  end

  private

  def classname
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize
      end
    end
  end

  def model_id
    params.each do |name, value|
      if name =~ /.+_id$/
        return name
      end
    end
    nil
  end

  def get_model
    @model = classname.find(params[model_id.to_sym])
  end

  def get_comment
    @comment = @model.comments.find(params[:id])
  end

  def can_destroy?
    @comment.created_at >= 15.minutes.ago && @comment.user_id == current_user.id
  end

  def can_update?
    can_destroy?
  end
end
