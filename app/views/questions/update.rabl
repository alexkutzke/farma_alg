glue @question do
  attributes :id, :title, :content, :available, :exp_variables

  child(:tips) do
    attributes :id, :content, :number_of_tries
  end
end
