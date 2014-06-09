# encoding: utf-8
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject
  field :content
  field :target_user_ids, type: Array
  field :user_ids, type: Array
  field :new_flag_user_ids, type: Array
  field :team_ids, type: Array
  field :answer_ids, type: Array
  field :question_ids, type: Array

  validates_presence_of :target_user_ids, :message => "Pelo menos um destinatário precisa ser informado"
  validates_presence_of :subject,:message => "A mensagem precisa ter um assunto"
  validates_presence_of :content,:message => "A mensagem precisa ter algum conteúdo"

	belongs_to :user
end
