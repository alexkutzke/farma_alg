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
  has_many :replies, dependent: :delete

  def has_recommendation?
    ((not self.answer_ids.nil?) and (not self.answer_ids.empty?)) || ((not self.question_ids.nil?) and (not self.question_ids.empty?)) 
  end

  def can_post?(user)
    (self.user_id == user.id) or (self.target_user_ids.include?(user.id.to_s))
  end
end
