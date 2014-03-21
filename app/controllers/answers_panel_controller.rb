class AnswersPanelController < ApplicationController
	layout "answers_panel"
	before_filter :authenticate_user!

	def index
		@answers = current_user.answers.where({question_id: params["question_id"]})
	end

	def answers
		links = Array.new

    #answers = Answer.where(question_id:"5319c5bc3cc4502b5b00005c").entries
    answers = Answer.all.entries
    
    for i in 0..answers.length-1
      answers[i]["neigh"] = Array.new
      for j in 0..answers.length-1
        c = Connection.where(answer_id:answers[i], target_answer_id:answers[j])
        unless c.empty?
          answers[i]["neigh"] << [answers[j]._id, c.first.weight, j]
        end
      end
    end

    answers[i]["neigh"].sort_by!{|x| x[1]}.reverse!

    @all = [answers]

    respond_to do |format|
    	format.json { render :json => @all }
    end
  end
end
