module Judge

  CASE_TEST_END = "<--FIM-->\n"

	def self.compile(lang="pas",source_code,id)

		# records the source code in a file
		File.open("/tmp/#{id}-response.#{lang}", 'w') {|f| f.write(source_code) }
    
    if lang == "pas"
      output = compile_pas("/tmp/#{id}-response.#{lang}",id)
    elsif lang == "c"
      output = compile_c("/tmp/#{id}-response.#{lang}",id)
    elsif lang == "rb"
      output = compile_rb("/tmp/#{id}-response.#{lang}",id)
    end


    return output
	end

	def self.compile_pas(filename,id)

		result = `bin/compile.sh pas #{filename} #{filename[0..-5]} #{filename}-compile_errors`

    result = result.split(/\n/).last

		if not (result.to_i == 0)
			return [1,simple_format(`cat #{filename}-compile_errors | tail -n +5 | sed -e 's/^#{id}-response.pas//'`)]
		else
			return [0,"#{filename[0..-5]}"]
		end
	end

  def self.compile_c(filename,id)

    result = `bin/compile.sh c #{filename} #{filename[0..-3]} #{filename}-compile_errors`
    result = result.split(/\n/).last

    if not (result.to_i == 0)
      return [1,simple_format(`cat #{filename}-compile_errors | sed -e 's#^#{filename}:##'`)]
    else
      return [0,"#{filename[0..-3]}"]
    end
  end

  def self.compile_rb(filename,id)

    result = `bin/compile.sh rb #{filename} #{filename[0..-4]} #{filename}-compile_errors`
    result = result.split(/\n/).last

    if not (result.to_i == 0)
      return [1,simple_format(`cat #{filename}-compile_errors | sed -e 's#^#{filename}:##'`)]
    else
      return [0,filename]
    end
  end

	def self.test(lang,filename,test_cases,id)
	  correct = Hash.new
    test_cases.each do |t|
      correct[t.id] = Array.new
      correct[t.id][2] = Array.new
      correct[t.id][1] = Array.new

      input = t.input.split(CASE_TEST_END)
      output = t.output.split(CASE_TEST_END)

      for i in 0..input.length-1
        File.open("/tmp/#{id}-input-#{t.id}-#{i}.dat", 'w') {|f| f.write(input[i]) }
        File.open("/tmp/#{id}-output-#{t.id}-#{i}.dat", 'w') {|f| f.write(output[i]) }
        
        Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        if lang == "rb"
          `bin/timeout3 -t #{t.timeout} ruby #{filename} < /tmp/#{id}-input-#{t.id}-#{i}.dat > /tmp/#{id}-output_response-#{t.id}-#{i}.dat`
           Rails.logger.info "bin/timeout3 -t #{t.timeout} ruby #{filename} < /tmp/#{id}-input-#{t.id}.dat &> /tmp/#{id}-output_response-#{t.id}-#{i}.dat"
        else
          `bin/timeout3 -t #{t.timeout} #{filename} < /tmp/#{id}-input-#{t.id}-#{i}.dat > /tmp/#{id}-output_response-#{t.id}-#{i}.dat`
          Rails.logger.info "bin/timeout3 -t #{t.timeout} #{filename} < /tmp/#{id}-input-#{t.id}-#{i}.dat &> /tmp/#{id}-output_response-#{t.id}-#{i}.dat"
        end
        Rails.logger.info $?.exitstatus
        # run ok
        if $?.exitstatus == 0 || $?.exitstatus == 255 || lang == "c"

          if t.ignore_presentation
            
            `diff -abBE /tmp/#{id}-output_response-#{t.id}-#{i}.dat /tmp/#{id}-output-#{t.id}-#{i}.dat`
            Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            Rails.logger.info "diff -abBE /tmp/#{id}-output_response-#{t.id}-#{i}.dat /tmp/#{id}-output-#{t.id}-#{i}.dat"
            Rails.logger.info $?.exitstatus

            # diff2 ok
            if $?.exitstatus == 0
              correct[t.id][2][i] = 0
            # diff2 fail
            else
              `numdiff -I --absolute-tolerance=0.001 /tmp/#{id}-output_response-#{t.id}-#{i}.dat /tmp/#{id}-output-#{t.id}-#{i}.dat`
              Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
              Rails.logger.info "numdiff --absolute-tolerance=0.001 -I /tmp/#{id}-output_response-#{t.id}-#{i}.dat /tmp/#{id}-output-#{t.id}-#{i}.dat"
              Rails.logger.info $?.exitstatus
              # diff2 ok
              if $?.exitstatus == 0
                correct[t.id][2][i] = 0
              # diff2 fail
              else
                correct[t.id][2][i] = 3
              end
            end
          else
            `diff -a /tmp/#{id}-output_response-#{t.id}-#{i}.dat /tmp/#{id}-output-#{t.id}-#{i}.dat`
            Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
            Rails.logger.info "diff -a /tmp/#{id}-output_response-#{t.id}-#{i}.dat /tmp/#{id}-output-#{t.id}-#{i}.dat"
            Rails.logger.info $?.exitstatus

            # diff1 ok
            if $?.exitstatus == 0
              correct[t.id][2][i] = 0
            # diff1 fail
            else
              `diff -abBE /tmp/#{id}-output_response-#{t.id}-#{i}.dat /tmp/#{id}-output-#{t.id}-#{i}.dat`
              Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
              Rails.logger.info "diff -abBE /tmp/#{id}-output_response-#{t.id}-#{i}.dat /tmp/#{id}-output-#{t.id}-#{i}.dat"
              Rails.logger.info $?.exitstatus

              # diff2 ok
              if $?.exitstatus == 0
                correct[t.id][2][i] = 2
              # diff2 fail
              else
                correct[t.id][2][i] = 3
              end
            end
          end
        # run fail
        else
          # could be time (143) of other failure (n)
          correct[t.id][2][i] = $?.exitstatus

          if lang == "rb"
            `{ bin/timeout3 -t #{t.timeout} ruby #{filename} ; } < /tmp/#{id}-input-#{t.id}-#{i}.dat > /tmp/#{id}-output_response-#{t.id}-#{i}.dat`
          else
            `{ bin/timeout3 -t #{t.timeout} #{filename} ; } < /tmp/#{id}-input-#{t.id}-#{i}.dat > /tmp/#{id}-output_response-#{t.id}-#{i}.dat`
          end

        end
        correct[t.id][1][i] = File.open("/tmp/#{id}-output_response-#{t.id}-#{i}.dat", "rb") {|io| io.read}

      end      

      correct[t.id][0] = 0
      for i in 0..input.length-1
        if correct[t.id][2][i] != 0
          correct[t.id][0] = correct[t.id][2][i]
          break
        end
      end

      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> Final"
      Rails.logger.info correct[t.id][0]
    end

    return correct
	end
end
