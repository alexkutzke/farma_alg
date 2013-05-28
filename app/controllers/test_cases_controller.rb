class TestCasesController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!
  before_filter :find_question

  def create
    @test_case = @question.test_cases.build(params[:test_case])
    if @test_case.save
      respond_with(@lo, @exercise, @question, @test_case)
    else
      respond_with(@lo, @exercise, @question, @test_case, status: 422)
    end
  end

  def show
    @test_case = @question.test_cases.find(params[:id])
    respond_with(@lo, @exercise, @question, @test_case)
  end

  def update
    @test_case = @question.test_cases.find(params[:id])

    if @test_case.update_attributes(params[:test_case])
      respond_with(@lo, @exercise, @question, @test_case)
    else
      respond_with(@lo, @exercise, @question, @test_case, status: 422)
    end
  end

  def destroy
    @test_case = @question.test_cases.find(params[:id])
    @test_case.destroy
    respond_with(@lo, @exercise, @question, @test_case)
  end

private
 def find_question
   if current_user.admin?
     @lo = Lo.find(params[:lo_id])
   else
     @lo = current_user.los.find(params[:lo_id])
   end
   @exercise = @lo.exercises.find(params[:exercise_id])
   @question = @exercise.questions.find(params[:question_id])
 end

end
