glue @exercise do
  attributes :id , :title, :content, :available
  node(:created_at) { |exer| l exer.created_at }
  node(:updated_at) { |exer| l exer.updated_at }

  child(:questions) do
    attributes :id, :title, :content, :available, :input, :output
    child(:tips) do
      attributes :id, :content, :number_of_tries
    end
  end
end
