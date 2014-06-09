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