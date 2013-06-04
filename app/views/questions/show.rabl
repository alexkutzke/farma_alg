glue @question do
  attributes :id, :title, :content, :available
	
	child(:test_cases) do
  	attributes :id, :content, :input, :output, :timeout, :tip
	end
end
