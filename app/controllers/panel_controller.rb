class PanelController < ApplicationController
	layout "retroaction", :only => [:retroaction]
  layout "dashboard"
	before_filter :authenticate_user!

	def index
		@my_teams = Team.where(owner_id: current_user.id).asc('name')
		@teams = current_user.teams.asc('name')
    @others = Array.new
    if current_user.admin?
      @others = Team.all.asc('name').entries - @my_teams
		end
    @last_comments = Comment.where(target_user_id: current_user.id).desc('created_at')[0..4]
    #@old_teams = Answer.all.distinct('team_id') - Team.all.entries
	end

  def comments
    @comments = Comment.where(target_user_id:current_user.id).desc('created_at')
  end

  def retroaction
    @answer = Answer.find(params[:answer_id])
    @other_answers = Hash.new
    @answer.exercise.questions.each do |q|
      if q.id != @answer.question_id
        @other_answers[q.id] = Hash.new

        #la = LastAnswer.where(user_id: @answer.user_id, question_id: q.id).try(:first)
        
        #if la
        #  @other_answers[q.id] = Answer.find(la.answer_id)
        #else
        #  @other_answers[q.id] = nil
        #end

        @other_answers[q.id][:answer] = Answer.where(user_id: @answer.user_id, question_id: q.id, team_id:@answer.team_id).lte(created_at: @answer.created_at).try(:first)
        @other_answers[q.id][:previous_answers] = (not @other_answers[q.id][:answer].nil?) ? @other_answers[q.id][:answer].previous(5) : []
      end
    end
  end

  def explorer
    
  end
end