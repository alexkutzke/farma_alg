collection @questions, object_root: false

attributes :id, :title, :content, :available, :languages

child(:test_cases) do
  attributes :id, :content, :input, :output, :timeout, :tip, :title, :ignore_presentation
end