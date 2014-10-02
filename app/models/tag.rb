# encoding: utf-8
class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :description
  field :type, type: Integer
  field :primary, type: Boolean, default: false

  belongs_to :user
  has_and_belongs_to_many :answers

  def self.create_primary
    Tag.create(:primary => true,
                            :description => "Erro de compilação - Identificado automaticamente",
                            :type => 2,
                            :name => "Compilação")
    Tag.create(:primary => true,
                            :description => "Erro de saída - Identificado automaticamente",
                            :type => 1,
                            :name => "Saída")
    Tag.create(:primary => true,
                            :description => "Tempo excedido - Identificado automaticamente",
                            :type => 1,
                            :name => "Tempo")
    Tag.create(:primary => true,
                            :description => "Erro de execução - Identificado automaticamente",
                            :type => 1,
                            :name => "Execução")
    Tag.create(:primary => true,
                            :description => "Erro de apresentação - Identificado automaticamente",
                            :type => 1,
                            :name => "Apresentação")
    Tag.create(:primary => true,
                            :description => "Resposta correta",
                            :type => 3,
                            :name => "Correta")
  end

  def self.apply_primary(answer)
    output = []
    # get the primary tags
    compile_error = Tag.find_or_create_by(:primary => true,
                            :description => "Erro de compilação - Identificado automaticamente",
                            :type => 2,
                            :name => "Compilação")
    diff_error = Tag.find_or_create_by(:primary => true,
                            :description => "Erro de saída - Identificado automaticamente",
                            :type => 1,
                            :name => "Saída")
    time_error = Tag.find_or_create_by(:primary => true,
                            :description => "Tempo excedido - Identificado automaticamente",
                            :type => 1,
                            :name => "Tempo")
    exec_error = Tag.find_or_create_by(:primary => true,
                            :description => "Erro de execução - Identificado automaticamente",
                            :type => 1,
                            :name => "Execução")
    presentation_error = Tag.find_or_create_by(:primary => true,
                            :description => "Erro de apresentação - Identificado automaticamente",
                            :type => 1,
                            :name => "Apresentação")
    correct = Tag.find_or_create_by(:primary => true,
                            :description => "Resposta correta",
                            :type => 3,
                            :name => "Correta")

    if not answer.correct
      if answer.compile_errors
        output << compile_error.id.to_s
      else
        answer.results.each do |k,v|
          if  v['diff_error']
            output << diff_error.id.to_s unless output.include?(diff_error.id.to_s)
          elsif v['time_error']
            output << time_error.id.to_s unless output.include?(time_error.id.to_s)
          elsif v['exec_error']
            output << exec_error.id.to_s unless output.include?(exec_error.id.to_s)
          elsif v['presentation_error']
            output << presentation_error.id.to_s unless output.include?(presentation_error.id.to_s)
          end
        end
      end
    else
      output << correct.id.to_s
    end
    output
  end

def self.correct
    compile_error = Tag.where(:primary => true,
                            :description => "Erro de compilao - Identificado automaticamente",
                            :type => 2,
                            :name => "Compilao").first
compile_error.name = "Compilação"
compile_error.description = "Erro de compilação - Identificado automaticamente"
compile_error.save!
end

end
