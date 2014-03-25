class Panel::AnswersController < ApplicationController
	layout "panel"
	before_filter :authenticate_user!
	before_filter :get_data

	def get_data
		@team = Team.find(params[:team_id])
		@user = User.find(params[:user_id])
		@lo = Lo.find(params[:lo_id])
		@question = Question.find(params[:question_id])
		@answer = Answer.find(params[:id])
	end

	def show
		@comment = Comment.new
		@comment.answer = @answer
		@comment.user_id = current_user.id
		@previous_answers = @answer.previous(5)
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

end