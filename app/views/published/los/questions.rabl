attributes :id, :title, :content,:languages

node :last_answer, if: lambda {|question| ( current_user && question.last_answers.by_user(current_user).size > 0 )} do |question|
  la = question.last_answers.by_user(current_user).first
  {
    compile_errors: la.answer.compile_errors,
    correct: la.answer.correct,
    response: la.answer.response,
    id: la.id,
    results: la.answer.results,
    question_id: la.answer.question_id,
  }
end

node :last_answers do |question|
  las = Answer.where(user_id: current_user.id, question_id: question.id).desc(:created_at)[0..4]  
  result = {}
  i = 0
  if las.length > 1
    las[0..-2].each do |la|
      result[i.to_s] = 
      {
        id: las[i].id,
        response: las[i].response,
        created_at: time_ago_in_words(las[i].created_at),
        previous: las[i+1].response,
        lang: la.lang,
        results: la.results,
        compile_errors: la.compile_errors,
        correct: la.correct
      }
      i = i+1
    end
  else
    las.each do |la|
      result[i.to_s] = 
      {
        id: las[i].id,
        response: las[i].response,
        created_at: time_ago_in_words(las[i].created_at),
        previous: "",
        lang: la.lang,
        results: la.results,
        compile_errors: la.compile_errors,
        correct: la.correct
      }
      i = i+1
    end
  end
  result
  result
end
