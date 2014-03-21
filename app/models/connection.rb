class Connection

  include Mongoid::Document
  include Mongoid::Timestamps

	belongs_to :answer

  field :target_answer_id, type: Moped::BSON::ObjectId
  field :weight, type: Float
  field :code_similarity, type: Float
  field :both_compile_errors, type: Integer
  field :compile_errors_similarity, type: Float
  field :both_error, type: Integer
  field :same_question, type: Integer
  field :test_case_similarity, type: Hash
	field :test_case_similarity_final, type: Float

  # a cada atualizacao tem que criar ou atualizar a conexao simetrica
  after_save :dup

  # duplica ou atualiza a conexao simetrica
  def dup
  	Connection.skip_callback("save", :after, :dup)
  	nc = Connection.find_or_initialize_by(target_answer_id:self.answer_id, answer_id:self.target_answer_id)
  	nc.weight = self.weight
  	nc.save!
  	Connection.set_callback("save", :after, :dup)
  end

end
