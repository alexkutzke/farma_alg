glue @lo do
  attributes :id, :name, :content

  node(:pages_count) { |lo| lo.pages_count }
  node(:pages) {|lo| lo.pages_with_name}

  child(:introductions) do
    attributes :id, :title, :content
  end

  child(:exercises) do
    attributes :id , :title, :content
    child(:questions) do
      attributes :id, :title, :content
      node :last_answer, if: lambda {|question| question.last_answers.by_user(current_user).size > 0} do |question|
        la = question.last_answers.by_user(current_user).first
        {
          tip: la.answer.tip,
          correct: la.answer.correct,
          response: la.answer.response,
          try_number: la.answer.try_number,
          id: la.id,
        }
      end
    end
  end
end
