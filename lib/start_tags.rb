as = Answer.all
for i in 0..as.count-1 do 
	a=as[i]
	a.tag_ids = []
	a.automatically_assigned_tags = []
	a.save!
end

Tag.delete_all

compile_error = Tag.create(:description => "Erro de compilação - Identificado automaticamente",
                        :type => 2,
                        :name => "Compilação")
diff_error = Tag.create(:description => "Erro de saída - Identificado automaticamente",
                        :type => 1,
                        :name => "Saída")
time_error = Tag.create(:description => "Tempo excedido - Identificado automaticamente",
                        :type => 1,
                        :name => "Tempo")
exec_error = Tag.create(:description => "Erro de execução - Identificado automaticamente",
                        :type => 1,
                        :name => "Execução")
presentation_error = Tag.create(:description => "Erro de apresentação - Identificado automaticamente",
                        :type => 1,
                        :name => "Apresentação")

for i in 0..as.count-1 do 
	a=as[i]
  if a.compile_errors
    a.tag_ids << compile_errors.id.to_s
  else
    a.results.each do |k,v|
      if  v['diff_error']
        a.tag_ids << diff_error.id.to_s
      elsif v['time_error']
        a.tag_ids << time_error.id.to_s
      elsif v['exec_error']
        a.tag_ids << exec_error.id.to_s
      elsif v['presentation_error']
        a.tag_ids << presentation_error.id.to_s
      end
    end
  end
  a.save!
end

