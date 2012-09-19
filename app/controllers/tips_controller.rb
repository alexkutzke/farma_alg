class TipsController < ApplicationController
  respond_to :json
  before_filter :find_question

  def create
    @tip = @question.tips.build(params[:tip])
    if @tip.save
      respond_with(@lo, @exercise, @question, @tip)
    else
      respond_with(@lo, @exercise, @question, @tip, status: 422)
    end
  end

  def show
    @tip = @question.tips.find(params[:id])
    respond_with(@lo, @exercise, @question, @tip)
  end

  def update
    @tip = @question.tips.find(params[:id])

    if @tip.update_attributes(params[:tip])
      respond_with(@lo, @exercise, @question, @tip)
    else
      respond_with(@lo, @exercise, @question, @tip, status: 422)
    end
  end

  def destroy
    @tip = @question.tips.find(params[:id])
    @tip.destroy
    respond_with(@lo, @exercise, @question, @tip)
  end

private
 def find_question
   @lo = Lo.find(params[:lo_id])
   @exercise = @lo.exercises.find(params[:exercise_id])
   @question = @exercise.questions.find(params[:question_id])
 end

end
