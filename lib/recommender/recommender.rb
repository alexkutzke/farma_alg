module Recommender

  def self.match_students(team_id,thres)
    users = User.any_of(team_ids: team_id).pluck(:id)
    #questions = Question.all.pluck(:id)

    questions = []
    Team.find(team_id).questions.each do |q|
      questions << q.id
    end
    final = []

    for i in 0..users.count-1 do
      u1 = users[i]
      final << {user_id: u1.to_s, neigh: []}
    end

    for i in 0..users.count-1 do
      u1 = users[i]
      neigh = []
      for j in (i+1)..users.count-1 do
        u2 = users[j]
        if u1.to_s != u2.to_s
          f_u1 = final.find{|x| x[:user_id] == u1.to_s}
          f_u2 = final.find{|x| x[:user_id] == u2.to_s}
          sum = 0.0
          num = 0
          avg = 0.0
          question_rank = []
          questions.each do |q|
            #as1 = Answer.where(user_id:u1.to_s,question_id:q.to_s,correct: false).pluck(:id).shuffle[0..3]
            #as2 = Answer.where(user_id:u2.to_s,question_id:q.to_s,correct: false).pluck(:id).shuffle[0..3]
            as1 = get_users_last_answers([u1.to_s],q.to_s)
            as2 = get_users_last_answers([u2.to_s],q.to_s)

            if as1.count > 0 and as2.count > 0
              as1.each do |a1|
                as2.each do |a2|
                  c = Connection.where(answer_id:a1.to_s, target_answer_id: a2.to_s)
                  unless c.empty?
                    sum = sum + c.first.weight
                    num = num + 1
                  end
                end
              end
              unless num == 0
                sum = sum / num
              end
              question_rank << {question_id: q.to_s, score: sum}
              avg = avg + sum
            end
          end

          unless question_rank.empty?
            avg = avg/question_rank.count
            #avg = avg/questions.count
          end
          question_rank.sort!{|x,y| y[:score] <=> x[:score]}
          if avg > thres
            f_u1[:neigh] << {user_id: u2.to_s, avg: avg, question_scores: question_rank}
            f_u2[:neigh] << {user_id: u1.to_s, avg: avg, question_scores: question_rank}
          end
        end
      end
      unless f_u1.nil?
        f_u1[:neigh].sort!{|x,y| y[:avg] <=> x[:avg]}
      end
    end

    final
  end

  def self.connected_components(matched_students,thres)


    not_visited = (0..matched_students.count-1).to_a
    components = []

    while not not_visited.empty?
      queue = [not_visited.shift]
      component = []
      while not queue.empty?
        visiting = queue.shift

        component << matched_students[visiting][:user_id]

        visiting_neigh = matched_students[visiting][:neigh]

        visiting_neigh.each do |neigh|
          if neigh[:avg] >= thres
            pos = matched_students.index{|x| x[:user_id] == neigh[:user_id]}
            if not_visited.include?(pos)
              queue.push(pos)
              not_visited.delete(pos)
            end

          end
        end
      end
      components << component
    end

    components.sort!{|x,y| y.count <=> x.count}
  end

  def self.find_most_relevant_questions(matched_students,component,thres)
    questions = []
    component.each do |user_id|
      pos = matched_students.index{|x| x[:user_id] == user_id}

      matched_students[pos][:neigh].each do |n|
        if n[:avg] >= thres
          questions = questions + n[:question_scores]
        end
      end
    end

    x = []
    questions.sort{|x,y| y[:question_id] <=> x[:question_id]}.chunk{|n| n[:question_id]}.each do |q,a|
      sum = 0.0
      a.each do |x|
        sum = sum + x[:score]
      end
      sum = sum / a.count
      x << [q,a.count,sum]
    end

    x.sort! do |x,y|
      if y[2] == x[2]
        y[1] <=> x[1]
      else
        y[2] <=> x[2]
      end
    end
  end

  def self.find_most_relevant_questions_in_team(ms,team_id,thres)
    cs = self.connected_components(ms,thres)
    components = []
    unless cs.empty?
      cs.each do |c|
        unless c.empty?
          components << [c,self.find_most_relevant_questions(ms,c,thres)]
        end
      end
    end
    components
  end

  def self.find_most_relevant_answers(user_ids,question_id)
    #as = Answer.in(:user_id => user_ids).where(question_id: question_id, correct: false).pluck(:id)
    #as = Answer.in(:user_id => user_ids).where(question_id: question_id, correct: false).pluck(:id).shuffle[0..30]
    as = get_users_last_answers(user_ids,question_id)
    avgs = []
    if as.count > 1
      as.each do |a1|
        sum = 0.0
        n = 0
        as.each do |a2|
          if a1.to_s != a2.to_s
            c = Connection.where(answer_id:a1.to_s, target_answer_id: a2.to_s)
            unless c.empty?
              sum = sum + c.first.weight
              n = n+1
            end
          end
        end
        unless n == 0
          sum = sum / n
        end
        avgs << [a1.to_s,sum]
      end
    else
      if as.count == 1
        return [[as.first.to_s,1.0]]
      end
    end

    avgs.sort!{|x,y| y[1] <=> x[1]}

  end

  def self.build_team_recommendations(team_id,thres)
    result = []

    ms = self.match_students(team_id.to_s,thres)

    n_thres = thres
    recommendation = []
    #while recommendation.empty? and n_thres > 0.0
      connected_components = self.find_most_relevant_questions_in_team(ms,team_id,thres)
      recommendation = []
      puts "Team: " + team_id.to_s + " (" + Team.find(team_id).users.count.to_s + " users)"
      puts "\tConnected Components: " + connected_components.count.to_s
      unless connected_components.empty?
        connected_components.each do |cc|
          puts "\t - " + cc.first.count.to_s + " users"
          n = 0
          unless cc[1].nil?
            cc[1].each do |question|
              a = self.find_most_relevant_answers(cc.first,question[0])
              answer_ids = []
              answer_scores = []
              unless a.nil?
                a.each do |i|
                  answer_ids << i[0]
                  answer_scores << i[1]
                end

                n += 1
                recommendation << {:team_id => team_id, :user_ids => cc.first, :answer_ids => answer_ids,:answer_scores => answer_scores, :question_id => question[0], :question_references => question[1], :question_score => question[2]}
              end
            end
            puts "\t\t - " + n.to_s + " recommendations"
          end
        end
      end

      n_thres = n_thres - 0.05
      if n_thres < 0.0
        n_thres = 0.0
      end
    #end

    recommendation
  end

  def self.build_recommendations(thres)
    users = User.all

    recommendations = []
    users.each do |u|
      team_ids = Team.where(owner_id:u.id.to_s, active:true).pluck(:id)

      team_ids.each do |team_id|
        recommendations << [team_id.to_s, self.build_team_recommendations(team_id.to_s,thres)]
      end
    end
    recommendations
  end

def self.create_recommendations(thres)

    user_ids = User.all.pluck(:id)

    all = Recommendation.all.entries
    #Recommendation.delete_active
#	Recommendation.delete_all

    user_ids.each do |user_id|
      team_ids = Team.where(owner_id:user_id.to_s, active: true).pluck(:id)
      #team_ids = Team.where(owner_id:user_id.to_s).pluck(:id)

      team_ids.each do |team_id|
        #recoms = self.build_team_recommendations(team_id.to_s,thres)
        #recoms.each do |recom|
        #  Recommendation.create(:type => "resposta_para_grupo", :item => recom, :user_id => user_id)
        #end

        puts "---------------------- 1"

        user_with_no_answers_ids = []
        users_by_wrong_answers = []
        questions_by_wrong_answers = []
        team_user_ids = Team.find(team_id).user_ids
        team_user_ids.each do |user_id2|
          if Answer.where(user_id: user_id2.to_s,team_id: team_id.to_s).empty?
            user_with_no_answers_ids << user_id2.to_s
          end
        end

        puts "---------------------- 2"

        users_by_wrong_answers = []
        Answer.in(user_id: team_user_ids).where(team_id: team_id, correct: false).asc(:user_id).chunk{|n| n[:user_id]}.each do |q,a|
          users_by_wrong_answers << [q,a.count]
        end
        p users_by_wrong_answers

        puts "---------------------- 3"

        questions_by_wrong_answers = []
        Answer.where(team_id: team_id.to_s, correct: false).sort{|x,y| y[:question_id] <=> x[:question_id]}.chunk{|n| n[:question_id]}.each do |q,a|
          questions_by_wrong_answers << [q,a.count]
        end


        puts "---------------------- 4"
        users_by_wrong_answers.sort!{|x,y| y[1] <=> x[1]}


        puts "---------------------- 5"
        unless users_by_wrong_answers.empty?
          users_ids_by_wrong_answers = []
          users_wrong_answers_count = []
          users_by_wrong_answers.each do |u|
            users_ids_by_wrong_answers << u[0]
            users_wrong_answers_count << u[1]
          end
          Recommendation.create(:type => "alunos_com_mais_incorretas", :item => {:user_ids => users_ids_by_wrong_answers[0..3], :count => users_wrong_answers_count[0..3], :team_id => team_id.to_s}, :user_id => user_id.to_s)
        end

        puts "---------------------- 6"
        unless questions_by_wrong_answers.empty?
          questions_ids_by_wrong_answers = []
          questions_wrong_answers_count = []
          questions_by_wrong_answers.each do |u|
            questions_ids_by_wrong_answers << u[0]
            questions_wrong_answers_count << u[1]
          end

          puts "---------------------- 7"
          as = []
          questions_ids_by_wrong_answers.each do |question_id|
            as << self.find_most_relevant_answers(team_user_ids,question_id)
          end

          puts "---------------------- 8"
          questions_ids_by_wrong_answers[0..3].each_index do |i|
            answer_ids = []
            answer_scores = []
            unless as[i].nil?
              as[i].each do |x|
                answer_ids << x[0]
                answer_scores << x[1]
              end
            end
            Recommendation.create(:type => "questao_com_mais_incorretas", :item => {:message_team_id => team_id.to_s, :answer_ids => answer_ids, :question_id => questions_ids_by_wrong_answers[i], :count => questions_wrong_answers_count[i], :team_id => team_id.to_s}, :user_id => user_id.to_s)
          end
        end

        puts "---------------------- 9"
        unless user_with_no_answers_ids.empty?
          Recommendation.create(:type => "alunos_sem_resposta", :item => {:user_ids => user_with_no_answers_ids, :team_id => team_id.to_s}, :user_id => user_id.to_s)
        end


      end
    end

    all.each do |r|
      r.delete
    end

  end

  def self.recommendation_in_words(recommendations)
    recommendations.each do |r|
      if not r[1].empty?
        puts "Para a turma '#{Team.find(r[0]).name}', recomendamos:"
        r[1].each do |recom|
          users = User.find(recom[:user_ids])
          puts
          puts "\tPara o seguinte grupo de alunos:"
          users.each do |u|
            puts "\t - " + u.name + " (" + u.email + ")"
          end

          puts "\tNa questão '#{Question.find(recom[:question_id]).title}', as seguintes respostas:"

          as = Answer.find(recom[:answer_ids])
          as.each_index do |a|
            puts "\t - " + as[a].user.name + " @ " + as[a].question.title + " #" + as[a].try_number.to_s + " (" + recom[:answer_scores][a].to_s + ")"
          end

        end
      else
        puts "Nenhuma recomendação para a turma '#{Team.find(r[0]).name}' neste momento."
      end
    end
    true
  end

  def self.get_users_last_answers(user_ids,question_id)
    result = []
    answers = Answer.in(:user_id => user_ids).where(question_id: question_id, correct: false)
    answers.only(:id,:user_id).asc(:user_id).chunk{|a| a[:user_id]}.each do |user,a|
      n = a.count
      if n > 1
        if n == 1
          result << a[0].id
        elsif n == 2
          result += [a[0], a[1]].map{|x| x.id}
        elsif n == 3
          result += [a[0], a[1], a[2]].map{|x| x.id}
        else
          result += [a[0], a[(n/2).to_i], a.last].map{|x| x.id}
        end
      end
    end
    unless answers.nil?
      if answers.count > 0
        result += answers.pluck(:id).shuffle[1..10]
        result.uniq!
      end
    end
    result
  end
end

