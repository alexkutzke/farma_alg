attributes :id, :title, :content

node :last_answer, if: lambda {|question| ( current_user && question.last_answers.by_user(current_user).size > 0 )} do |question|
  la = question.last_answers.by_user(current_user).first
  #debugger
  {
    compile_errors: la.answer.compile_errors,
    correct: la.answer.correct,
    response: la.answer.response,
    id: la.id,
    results: la.answer.results,
    question_id: la.answer.question_id
  }
end
