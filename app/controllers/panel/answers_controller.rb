class Panel::AnswersController < ApplicationController
	layout "dashboard"
	before_filter :authenticate_user!
	before_filter :get_data

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:user_id])
		@lo = Lo.find(params[:lo_id])
		@question = Question.find(params[:question_id])
		@answer = Answer.find(params[:id])


		if current_user.prof? && (not current_user.admin?)
			unless current_user.all_team_ids.include?(@answer.team_id)
				render_401
				return false
			end
		end

		unless current_user.prof?
			unless current_user.team_ids.include?(@team.id)
				render_401
				return false
			end
			unless current_user.team_ids.include?(@team.id)
				render_401
				return false
			end
			unless current_user.id == @answer.user_id
				render_401
				return false
			end
		end

	end

	def show
		@comment = Comment.new
		@comment.answer = @answer
		@comment.user_id = current_user.id
		@previous_answers = @answer.previous(5)
		@correct = Answer.where(user_id: params[:user_id], question_id: params[:question_id], correct: true).count > 0 ? true : false
		Log.log_answer_view(current_user.id,@answer.id)
	end

  def change_correctness
    if current_user.admin? || current_user.id == @team.owner_id
      @answer.changed_correctness = true
      options = {:hard_wrap => true, :filter_html => true, :autolink => true,
               :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
      @answer.changed_correctness_reason = markdown.render(params[:answer][:changed_correctness_reason]).html_safe.gsub(/"/,'&quot').gsub(/\n/,'')
      if @answer.correct
        @answer.correct = false
      else
        @answer.correct = true
      end
      @answer.save!
    end

    redirect_to panel_team_user_lo_question_answer_path(@team,@user,@lo,@question,@answer)
  end

	def try_again
		if @user.id == current_user.id
			if Team.find(@answer.team_id).lo_ids.include?(@answer.lo_id)
				Log.log_answer_try_again_click(current_user.id,@answer.id)
				redirect_to current_user.link_to_question(Question.find(@answer.question_id))
				return
			end
		end

		render_401
	end

end
