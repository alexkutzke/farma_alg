glue @exercise do
  attributes :id , :title, :content, :available
  node(:created_at) { |exer| l exer.created_at }
  node(:updated_at) { |exer| l exer.updated_at }

  child(:questions) do
    attributes :id, :title, :content, :available, :correct_answer, :exp_variables, :many_answers, :position
    child(:tips) do
      attributes :id, :content, :number_of_tries
    end
  end
end
