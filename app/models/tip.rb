# encoding: utf-8
class Tip
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :number_of_tries, type: Integer, default: 1

  default_scope order_by([:number_of_tries, :desc])

  attr_accessible :id, :content, :number_of_tries

  validates_presence_of :content, :number_of_tries
  validates :number_of_tries, numericality: { only_integer: true, greater_than: 0, less_than: 15 }
  validates :number_of_tries, uniqueness: { scope: :question_id,
            message: "Já existe uma dica cadastrada com esse número de tentativas" }

  belongs_to :question
end
