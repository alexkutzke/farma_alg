# encoding: utf-8
namespace :xls do
  # ******** to excel *********** #
  class Array
    def to_xls
      content = ''
      self.each do |row|
        row.map! {|col| col = col.to_s.gsub(/(\t|\r\n|\r|\n)/, " ").gsub(/ +/, " ") }
        content << row.join("\t")
        content << "\n"
      end
      content
    end
  end
  # ********* end *************** #

  desc "Create a xls document"
  task :generate => :environment do
    datas = []
    headers = ['Turma', 'Aprendiz', 'Exercício', 'Questão', 'Ocorrido em', 'Resposta', 'Correta', 'Resposta Correta']
    datas.push headers

    answers = Answer.every.sort {|a,b| a.user.name <=> b.user.name }
    answers = answers.select {|a| a.lo.name = 'MIX' }

    answers.each do |answer|
      datas.push [answer.team.name, answer.user.name, answer.exercise.title, answer.question.title,
       I18n.l(answer.created_at), answer.response, answer.correct?, answer.question.correct_answer ]
    end

    f = File.new("answers.xls", "w+")
    f << datas.to_xls
    f.close
  end
end
