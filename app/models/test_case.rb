# encoding: utf-8
class TestCase
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: String
  field :tip, type: String
  field :input, type: String
  field :output, type: String
  field :timeout, type: Integer, default: 1
  field :ignore_presentation, type: Boolean, default: true
  field :has_check_program, type: Boolean, default: false
  field :check_program, type: String
  field :show_input_output, type: Boolean, default: true
  field :tip_limit, type: Integer, default: 1

  attr_accessible :id, :content, :input, :output, :timeout, :tip, :title, :ignore_presentation, :show_input_output, :tip_limit, :has_check_program, :check_program, :question_id, :lo_id, :exercise_id

  validates_presence_of :content, :timeout, :title
  validates :timeout, numericality: { only_integer: true, greater_than: 0, less_than: 100 }

  belongs_to :question

  validate :compile_check_program

  def compile_check_program
      puts "------------------------------------------------------------"
      puts "------------------------------------------------------------"
      puts "------------------------------------------------------------"
      puts "------------------------------------------------------------"

      errors.add(:check_program, "check program está incorreto.")
  end
end
