class DashboardController < ApplicationController
	layout "dashboard"

  before_filter :authenticate_user!
  before_filter :verify_prof, :only =>[:graph,:graph_search,:graph_answer_info,:graph_search_result,:graph_connection_info,:graph_add_tag,:graph_new_tag,:graph_create_tag]

  def verify_prof
    unless current_user.prof?
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
    @boxes = []
		@last_messages = current_user.last_messages_to_me(4)

    if current_user.prof?
			@recommendations = Recommendation.where(user_id:current_user.id.to_s).all.entries

			num_students = 0
			num_students_correct_answers = 0
			num_students_wrong_answers = 0
			team_ids = Team.where(owner_id:current_user.id.to_s).pluck(:id)
			team_ids.each do |team_id|
				t = Team.find(team_id.to_s)
				num_students = num_students + t.user_ids.count
				num_students_correct_answers = num_students_correct_answers + Answer.where(:team_id => t.id.to_s, :correct => true).count
				num_students_wrong_answers = num_students_wrong_answers + Answer.where(:team_id => t.id.to_s, :correct => false).count
			end

			num_wrong_answers = Answer.where(user_id: current_user.id,:correct => false).count
			num_correct_answers = Answer.where(user_id: current_user.id,:correct => true).count

      @boxes << {:color => "bg-orange", :value => team_ids.count, :title => "Número de turmas", :has_link? => false, :icon => "fa fa-book"}
      @boxes << {:color => "bg-aqua", :value => num_students, :title => "Número de alunos", :has_link? => false, :icon => "fa fa-users"}
      @boxes << {:color => "bg-red", :value => num_students_wrong_answers, :title => "Número de respostas incorretas", :has_link? => false, :icon => "fa fa-times"}
      @boxes << {:color => "bg-green", :value => num_students_correct_answers, :title => "Número de respostas corretas", :has_link? => false, :icon => "fa fa-check"}

			@last_answers = Answer.in(team_id: team_ids).desc(:created_at)[0..4]
			@last_comments = Comment.in(team_id: team_ids).desc('created_at')[0..4]
		else
			@last_answers = Answer.where(user_id: current_user.id).desc(:created_at)[0..4]
			last_try = current_user.last_try
			num_wrong_answers = Answer.where(:user_id => current_user.id, :correct => false).count
			num_correct_answers = Answer.where(:user_id => current_user.id, :correct => true).count
			num_questions_without_tries = current_user.questions_without_tries.count
			num_teams = current_user.teams.count

			@boxes << {:color => "bg-red", :value => num_wrong_answers, :title => "Número de respostas incorretas", :has_link? => false, :icon => "fa fa-times"}
			@boxes << {:color => "bg-green", :value => num_correct_answers, :title => "Número de respostas corretas", :has_link? => false, :icon => "fa fa-check"}
			@boxes << {:color => "bg-orange", :value => num_questions_without_tries, :title => "Número de questões sem tentativas", :has_link? => false, :icon => "fa fa-warning"}
			@boxes << {:color => "bg-blue", :value => num_teams, :title => "Número de turmas matriculadas", :has_link? => false, :icon => "fa fa-book"}
			unless last_try.nil?
				@boxes << {:color => ( last_try.correct ? "bg-green" : "bg-red"), :value => last_try.question.title.truncate(10), :title => "Última tentativa", :has_link? => true, :icon => "fa " + (last_try.correct ? "fa-check" : "fa-times"), :link => panel_team_user_lo_question_answer_path(last_try.team_id,last_try.user_id,last_try.lo_id,last_try.question_id,last_try.id) }
			end
    end

		@boxes.shuffle!
	end

  def timeline
    init_search
  end

  def timeline_search
    @as = Answer.search(params,current_user).entries
		@total = @as.count
		@as = @as.first(50)
    @timeline_items = Answer.make_timeline(@as)
		@params=params

    render 'timeline_search_result'
  end

  def search
    init_search
  end

  def tags
    init_search
  end

  def tags_search
		@as = Answer.search(params,current_user).entries
		@total = @as.count
		@as = @as.first(50)
    #@as_aat = Answer.search_aat(params,current_user)
		@params =params

    render 'tags_search_result'
  end

	def tags_search_aat
		@as_aat = Answer.search_aat(params,current_user)
		@total = @as_aat.count
		@as = @as_aat.first(50)
		render 'tags_search_aat_result'
	end

  def fulltext_search
		if params.has_key?(:page)
			page = params[:page]
		else
			page = 1
		end
    @as = Answer.search(params,current_user,page)
    @button_add = true
    @button_add = false unless params.has_key?(:button_add)
		@params =params

    render 'search_result'
  end

  def graph
    init_search
  end

  def graph_search
		@as = Answer.search(params,current_user).entries
		@total = @as.count
		@as = @as.first(50)
		@params =params

    render 'graph_search_result'
  end

	def hide_help
		current_user.show_help = false
		current_user.save
	end

	def help
	end

end
