glue @question do
  attributes :id, :title, :content, :available, :languages

	child(:test_cases) do
  	attributes :id, :content, :input, :output, :timeout,:tip, :title, :ignore_presentation, :show_input_output, :tip_limit, :has_check_program, :check_program
	end
end
