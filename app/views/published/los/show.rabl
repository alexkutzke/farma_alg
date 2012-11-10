glue @lo do
  attributes :id, :name, :content

  node(:pages_count) { |lo| lo.pages_count }
  node(:pages) {|lo| lo.pages_with_name}

  node :introductions do |parent|
    parent.introductions_avaiable.map do |introduction|
      result = {}
      result['id'] = introduction.id
      result['title'] = introduction.title
      result['content'] = introduction.content
      result
    end
  end

  node :exercises do |parent|
    parent.exercises_avaiable.map do |exercise|
      result = {}
      result['id'] = exercise.id
      result['title'] = exercise.title
      result['content'] = exercise.content
      result['questions'] = partial("published/los/questions", :object => exercise.questions_avaiable)
      result
    end
  end
end
