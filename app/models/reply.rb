# encoding: utf-8
class Reply
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content

  validates_presence_of :content,:message => "A mensagem precisa ter algum conteúdo"

  belongs_to :user
  belongs_to :message
end
