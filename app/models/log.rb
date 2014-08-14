# encoding: utf-8
class Log
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type
  field :user_id
  field :params, type: Hash

  # TYPES
  # MSG_SENT
  # MSG_SENT_RECOM
  # RECOM_CLICK
  # MSG_VIEW


  def self.log_message_sent(user_id,message_id)
    Log.create(type: "MSG_SENT", params: {message_id: message_id}, user_id: user_id)
  end

  def self.log_message_sent_with_recommendation(user_id,message_id)
    Log.create(type: "MSG_SENT_RECOM", params: {message_id: message_id}, user_id: user_id)
  end

  def self.log_recommendation_click(user_id,params)
    Log.create(type: "RECOM_CLICK",params:  params, user_id: user_id)
  end

  def self.log_message_view(user_id,message_id)
    Log.create(type: "MSG_VIEW",params:  {message_id: message_id}, user_id: user_id)
  end

  def self.log_answer_view_simple(user_id,answer_id)
    Log.create(type: "ANSWER_VIEW_SIMPLE",params: {answer_id:answer_id}, user_id: user_id)
  end

  def self.log_answer_view(user_id,answer_id)
    Log.create(type: "ANSWER_VIEW", params: {answer_id:answer_id}, user_id: user_id)
  end

  def self.log_answer_try_again_click(user_id,answer_id)
    Log.create(type: "ANSWER_TRY_AGAIN_CLICK", params: {answer_id:answer_id}, user_id: user_id)
  end

  def self.log_connection_view_simple(user_id,connection_id)
    Log.create(type: "CONNECTION_VIEW_SIMPLE", params:{connection_id:connection_id}, user_id: user_id)
  end

  def self.log_connection_create(user_id,connection_id)
    Log.create(type: "CONNECTION_CREATE", params:{connection_id:connection_id}, user_id: user_id)
  end

  def self.log_connection_accept(user_id,connection_id)
    Log.create(type: "CONNECTION_ACCEPT", params:{connection_id:connection_id}, user_id: user_id)
  end

  def self.log_connection_reject(user_id,params)
    Log.create(type: "CONNECTION_REJECT", params:params, user_id: user_id)
  end

  def self.log_search_simple(user_id,params)
    Log.create(type: "SEARCH_SIMPLE", params: params, user_id: user_id)
  end

  def self.log_search_timeline(user_id,params)
    Log.create(type: "SEARCH_TIMELINE", params: params, user_id: user_id)
  end

  def self.log_search_tag(user_id,params)
    Log.create(type: "SEARCH_TAG", params: params, user_id: user_id)
  end

  def self.log_search_graph(user_id,params)
    Log.create(type: "SEARCH_GRAPH", params: params, user_id: user_id)
  end

  def self.log_add_tag(user_id,answer_id,tag_id)
    Log.create(type: "TAG_ADD", params: {answer_id:answer_id,tag_id:tag_id}, user_id: user_id)
  end

  def self.log_accept_tag(user_id,answer_id,tag_id)
    Log.create(type: "TAG_ACCEPT", params: {answer_id:answer_id,tag_id:tag_id}, user_id: user_id)
  end

  def self.log_remove_tag(user_id,answer_id,tag_id)
    Log.create(type: "TAG_REMOVE", params: {answer_id:answer_id,tag_id:tag_id}, user_id: user_id)
  end

  def self.log_reject_tag(user_id,answer_id,tag_id)
    Log.create(type: "TAG_REJECT", params: {answer_id:answer_id,tag_id:tag_id}, user_id: user_id)
  end

  def self.log_graph_view(user_id)
    Log.create(type: "GRAPH_VIEW", user_id: user_id)
  end

  def self.log_graph_add_similar(user_id,answer_id)
    Log.create(type: "GRAPH_ADD_SIMILAR", params: {answer_id:answer_id}, user_id: user_id)
  end

  def self.log_graph_add_connected_component(user_id,answer_id)
    Log.create(type: "GRAPH_ADD_CONNECTED", params: {answer_id:answer_id}, user_id: user_id)
  end

  def self.log_graph_add(user_id,answer_id)
    Log.create(type: "GRAPH_ADD", params: {answer_id:answer_id}, user_id: user_id)
  end

  def self.log_graph_add_group(user_id,answer_ids)
    Log.create(type: "GRAPH_ADD_GROUP", params: answer_ids, user_id: user_id)
  end

  def self.log_team_view(user_id,team_id)
    Log.create(type: "TEAM_VIEW", params: {team_id:team_id}, user_id: user_id)
  end

  def self.log_team_user_view(user_id,team_id,user2_id)
    Log.create(type: "TEAM_USER_VIEW", params: {team_id:team_id, user_id:user2_id}, user_id: user_id)
  end

  def self.log_team_user_lo_view(user_id,team_id,user2_id,lo_id)
    Log.create(type: "TEAM_USER_LO_VIEW", params: {team_id:team_id, user_id:user2_id, lo_id:lo_id}, user_id: user_id)
  end

  def self.log_team_user_lo_question_view(user_id,team_id,user2_id,lo_id,question_id)
    Log.create(type: "TEAM_USER_LO_QUESTION_VIEW", params: {team_id:team_id, user_id:user2_id, lo_id:lo_id, question_id:question_id}, user_id: user_id)
  end

  def self.log_team_lo_overview_view(user_id,team_id,lo_id)
    Log.create(type: "TEAM_LO_OVERVIEW_VIEW", params: {team_id:team_id, lo_id:lo_id}, user_id: user_id)
  end

end
