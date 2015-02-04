glue @exercise do
  attributes :id , :title, :content, :available
  node(:created_at) { |exer| l exer.created_at }
  node(:updated_at) { |exer| l exer.updated_at }

  child(:questions) do
    attributes :id, :title, :content, :available, :input, :output, :languages
    child(:test_cases) do
      attributes :id, :content, :input, :output, :timeout, :tip, :title, :ignore_presentation, :show_input_output, :tip_limit, :has_check_program, :check_program
    end
  end
end
