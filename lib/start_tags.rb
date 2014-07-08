as = Answer.all.entries
for i in 0..as.count-1 do 
	a=as[i]
	a.tag_ids = []
	a.automatically_assigned_tags = []
	a.save!
end

for i in 0..as.count-1 do 
	a=as[i]
  if a.compile_errors
    a.tag_ids << "538f199fe3bdeabc6e000001"
  else
    a.results.each do |k,v|
      if  v['diff_error']
        a.tag_ids << "538f19cfe3bdeabc6e000002"
      elsif v['time_error']
        a.tag_ids << "538f19ebe3bdeabc6e000003"
      elsif v['exec_error']
        a.tag_ids << "538f1a36e3bdeabc6e000005"
      elsif v['presentation_error']
        a.tag_ids << "538f19fce3bdeabc6e000004"
      end
    end
  end
  a.save!
end

