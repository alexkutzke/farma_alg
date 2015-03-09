#encoding: utf-8
module SimilarityMachine

  def self.string_similarity(a,b)
    if a.nil? || b.nil?
      0.0
    else
      #a.pair_distance_similar(b)
      a.levenshtein_similar(b)
    end
  end

  # Define um valor real de 0 à 1 para a similaridade
  # entre duas respostas a e b
  def self.similarity(a,b)

    tmp = Time.now.to_i

    File.open("/tmp/#{tmp}-#{a.id}-response.#{a.lang}", 'w') {|f| f.write(a.response) }
    File.open("/tmp/#{tmp}-#{b.id}-response.#{b.lang}", 'w') {|f| f.write(b.response) }

    # code similarity
    if Rails.env.production?
      code_similarity = `/usr/bin/sim_pasc -e -s -p /tmp/#{tmp}-#{a.id}-response.#{a.lang} /tmp/#{tmp}-#{b.id}-response.#{b.lang} | grep consists | grep '^/tmp/#{tmp}-#{a.id}-response.#{a.lang}' | cut -d " " -f4`.to_f / 100.0
    else
      code_similarity = `/opt/similarity-tester/sim_pasc -e -s -p /tmp/#{tmp}-#{a.id}-response.#{a.lang} /tmp/#{tmp}-#{b.id}-response.#{b.lang} | grep consists | grep '^/tmp/#{tmp}-#{a.id}-response.#{a.lang}' | cut -d " " -f4`.to_f / 100.0
    end

    File.delete("/tmp/#{tmp}-#{a.id}-response.#{a.lang}")
    File.delete("/tmp/#{tmp}-#{b.id}-response.#{b.lang}")

    # compile errors similarity
    both_compile_errors = 0
    compile_errors_similarity = 0
    if a.compile_errors && b.compile_errors
      both_compile_errors = 1
      compile_errors_similarity = string_similarity(a.compile_errors,b.compile_errors)
    end

    both_error = (not a.correct) && (not b.correct) ? 1 : 0

    same_question = a.question_id == b.question_id ? 1 : 0

    test_case_similarity_final = 0
    if same_question
      # test case similarity
      test_case_similarity = Hash.new
      unless a.results.nil? || b.results.nil?
        a.results.each do |id,result_a|
          test_case_similarity[id] = Hash.new

          result_b = b.results[id] unless b.results[id].nil?
          unless result_b.nil?
            test_case_similarity[id]['error'] = result_a['error'] || result_b['error'] ? 1 : 0
            test_case_similarity[id]['both_error'] = result_a['error'] && result_b['error'] ? 1 : 0

            test_case_similarity[id]['same_error'] = (result_a['diff_error'] && result_b['diff_error']) ||
                                                      (result_a['time_error'] && result_b['time_error']) ||
                                                      (result_a['exec_error'] && result_b['exec_error']) ||
                                                      (result_a['presentation_error'] && result_b['presentation_error']) ? 1 : 0

            test_case_similarity[id]['output_similarity'] = string_similarity(result_a['output'],result_b['output'])
            test_case_similarity[id]['output_a'] = result_a['output']
            test_case_similarity[id]['output_b'] = result_b['output']
            test_case_similarity[id]['output_expected'] = result_b['output_expected']

            tc = TestCase.find_or_initialize_by(id:id)

            test_case_similarity[id]['diff_to_expected_output'] = (string_similarity(result_a['output'],tc.output) - string_similarity(result_b['output'],tc.output)).abs

            tmp = test_case_similarity[id]['output_similarity'] + (1 - test_case_similarity[id]['diff_to_expected_output']) + ((1 - test_case_similarity[id]['error']) * 2) + test_case_similarity[id]['both_error'] + test_case_similarity[id]['same_error']
          end
          test_case_similarity_final = test_case_similarity_final + tmp
        end
        if a.results.count > 0
          test_case_similarity_final = test_case_similarity_final / a.results.count
        end
      end
    end

    result = Hash.new

    #puts "code_similarity: " + code_similarity.to_s
    #puts "both_compile_errors: " + both_compile_errors.to_s
    #puts "compile_errors_similarity: " + compile_errors_similarity.to_s
    #puts "both_error: " + both_error.to_s
    #puts "same_question: " + same_question.to_s

    if same_question
      test_case_similarity.each do |id,data|
        #puts "test case: " + id.to_s
        #puts "\terror: " + data['error'].to_s
        if data['error']
          #puts "\tsame_error: " + data['same_error'].to_s
        end
        #puts "\toutput_similarity: " + data['output_similarity'].to_s
        #puts "diff_to_expected_output: " + test_case_similarity[id]['diff_to_expected_output'].to_s
      end
    end

    final_similarity = (0.3*code_similarity + 0.7*(both_compile_errors * compile_errors_similarity) + 0.7*(1.0 - both_compile_errors) * (same_question*test_case_similarity_final/4.0)) /2.0
    #puts "final_similarity: " + final_similarity.to_s

    result['code_similarity'] = code_similarity
    result['both_compile_errors'] = both_compile_errors
    result['compile_errors_similarity'] = compile_errors_similarity
    result['both_error'] = both_error
    result['same_question'] = same_question
    result['test_case_similarity'] = test_case_similarity
    result['test_case_similarity_final'] = test_case_similarity_final
    result['final_similarity'] = final_similarity


    result
  end

  def self.create_connection(a,b)
    c = nil

    if a.user_id != b.user_id or (a.user_id == b.user_id and a.try_number == b.try_number + 1)
      result = similarity(a,b)
      c = Connection.find_or_initialize_by(target_answer_id:b.id, answer_id:a.id)

      if result['final_similarity'] > 0.4
        c.code_similarity = result['code_similarity']
        c.both_compile_errors = result['both_compile_errors']
        c.compile_errors_similarity = result['compile_errors_similarity']
        c.both_error = result['both_error']
        c.same_question = result['same_question']
        c.test_case_similarity = result['test_case_similarity']
        c.test_case_similarity_final = result['test_case_similarity_final']
        c.weight = result['final_similarity']
        c.save!
      end
    end
    c
  end

  def self.create_answer_neighbor(answer)
    per_batch = 1000

    0.step(Answer.count, per_batch) do |offset|
      Answer.limit(per_batch).skip(offset).each do |a|
        if a.id != answer.id
          create_connection(answer,a)
        end
      end
    end
  end

  def self.match_all
    Connection.delete_all

    # per_batch = 1000
    # i = 0.0
    # t = Answer.count**2.0
    # 0.step(Answer.count, per_batch) do |offset|
    #   Answer.limit(per_batch).skip(offset).each do |a|
    #     0.step(Answer.count, per_batch) do |offset2|
    #       Answer.limit(per_batch).skip(offset2).each do |b|
    #         i = i + 1.0
    #         puts (i*100.0)/t
    #         if a.id != b.id
    #           puts a.id.to_s + " " + b.id.to_s
    #           create_connection(a,b)
    #         end
    #       end
    #     end
    #   end
    # end

    #Team.each do |team|
    team = Team.find("530f7e003cc4501f13000010")
      t = Answer.where(team_id: team.id).count
      t *= t
      i = 0.0
      Answer.where(team_id: team.id).no_timeout.each do |a|
        Answer.where(team_id: team.id).no_timeout.each do |b|
          i = i + 1.0
          puts (i*100.0)/t
          if a.id != b.id and a.question_id == b.question_id
            if a.user_id != b.user_id or (a.user_id == b.user_id and a.try_number == b.try_number + 1)
              puts a.id.to_s + " " + b.id.to_s
              create_connection(a,b)
            end
          end
        end
      end
    #end
    true
  end

  def self.start
    puts "Corrigindo tags..."

    t = Answer.count
    i = 1
    Answer.all.no_timeout.each do |a|
      print i.to_s + "/" + t.to_s + "\r"
      i += 1
      a.tags.destroy
      a.tag_ids = []
      a.automatically_assigned_tags = []
      a.rejected_tags = []
      a.save!
    end

    Tag.delete_all

    i=1
    Answer.all.no_timeout.each do |a|
      print i.to_s + "/" + t.to_s + "\r"
      a.primary_applied = false
      a.apply_primary_tags
      i += 1
    end

    Connection.delete_all

    i=1
    puts "Criando conexoes"
    Answer.all.no_timeout.each do |a|

      #print i.to_s + "/" + t.to_s + "\r"
      print i.to_s + "/" + t.to_s
      puts
      puts a.id

      a.make_inner_connections
      a.make_outer_connections

      i = 1 + i
    end
  end

  def self.get_similarity(a,b)
    result = self.similarity(a,b)
    c = Connection.find_or_initialize_by(target_answer_id:b.id, answer_id:a.id)

    unless c.new_record?
      result['final_similarity'] = c.weight
    end
    result
  end
end
