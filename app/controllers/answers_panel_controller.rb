class AnswersPanelController < ApplicationController
	layout "answers_panel"
	before_filter :authenticate_user!

	def index
		@answers = current_user.answers.where({question_id: params["question_id"]})
	end

	def answers
		links = Array.new

		answers = current_user.answers.where({question_id: params["question_id"]}).entries

		for i in 0..answers.length-1
			links[i] = Array.new
			answers[i]["neigh"] = Array.new
			for j in 0..answers.length-1
				p "working ..." + i.to_s + "," + j.to_s
				links[i][j] = 0
				if i != j
					total = 0
					ok = 0
					
					if (not answers[i].compile_errors.nil?) && (not answers[j].compile_errors.nil?)
						ok = 1
						a = answers[i].compile_errors
						b = answers[j].compile_errors
					elsif answers[i].compile_errors.nil? && answers[j].compile_errors.nil?
						ok = 1
						for k in 0..answers[i].results.length-1 do
							r1 = answers[i].results.to_a[k][1]
							r2 = answers[j].results.to_a[k][1]
							if not r1["output"].nil?
								a = r1["output"]
							else
								a = ""
							end
							if not r2["output"].nil?
								b = r2["output"]
							else
								b = ""
							end

							#debugger
						end
					else
						if not answers[i].response.nil?
							a = answers[i].response
						else
							a = ""
						end
						if not answers[j].response.nil?
							b = answers[j].response
						else
							b = ""
						end
					end


					if ok == 1
						if a == b
							links[i][j] = 1
						else
							m = Amatch::PairDistance.new(a+".")
							size = a.length > b.length ? a.length : b.length
							links[i][j] = m.match(b+".").to_f#/size.to_f
						end
					end

					answers[i]["neigh"] << [answers[j]._id, links[i][j], j]
					#tmp = Time.now.to_i

    			#File.open("/tmp/#{tmp}-1.out", 'w') {|f| f.write(a) }
    			#File.open("/tmp/#{tmp}-2.out", 'w') {|f| f.write(b) }

    			#links[i][j] = `/Users/alexkutzke/Downloads/sim/sim_text -p /tmp/#{tmp}-1.out /tmp/#{tmp}-2.out | tail -1 | cut -d " " -f4`
    		end
    		answers[i]["neigh"].sort_by!{|x| x[1]}.reverse!
    	end
    end

    @all = [answers,links]


    respond_to do |format|
    	format.json { render :json => @all }
    end
  end
end
