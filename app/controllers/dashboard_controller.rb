class DashboardController < ApplicationController
	layout "dashboard"

  before_filter :authenticate_user!
  before_filter :verify_admin, :only =>[:graph,:graph_search,:graph_answer_info,:graph_search_result,:graph_connection_info,:graph_add_tag,:graph_new_tag,:graph_create_tag]

  def verify_admin
    unless current_user.admin?
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
    @recommendations = Recommendation.where(user_id:current_user.id.to_s).sample(4)
    @boxes = []

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

    if current_user.admin?
      @boxes << {:color => "bg-orange", :value => team_ids.count, :title => "Número de turmas", :has_link? => false, :icon => "fa fa-book"}
      @boxes << {:color => "bg-aqua", :value => num_students, :title => "Número de alunos", :has_link? => false, :icon => "fa fa-users"}
      @boxes << {:color => "bg-red", :value => num_students_wrong_answers, :title => "Número de respostas incorretas", :has_link? => false, :icon => "fa fa-times"}
      @boxes << {:color => "bg-green", :value => num_students_correct_answers, :title => "Número de respostas corretas", :has_link? => false, :icon => "fa fa-check"}
    end

    @last_answers = Answer.in(team_id: team_ids).desc(:created_at)[0..4]
    @last_comments = Comment.in(team_id: team_ids).desc('created_at')[0..4]
	end

  def timeline
    init_search
  end

  def timeline_search
    @as = Answer.search(params,current_user).entries
    @timeline_items = Answer.make_timeline(@as)

    render 'timeline_search_result'
  end

  def search
    init_search
  end

  def tags
    init_search
  end

  def tags_search
    @as = Answer.search(params,current_user)
    @as_aat = Answer.search_aat(params,current_user)
    
    render 'tags_search_result'
  end

  def fulltext_search
    @as = Answer.search(params,current_user)
    @button_add = true
    @button_add = false unless params.has_key?(:button_add)
    
    render 'search_result'
  end
  
  def graph
    init_search
  end

  def graph_search
    @as = Answer.search(params,current_user)
    
    render 'graph_search_result'
  end

end