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
    end
  end
end
