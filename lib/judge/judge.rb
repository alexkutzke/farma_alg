module Judge
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

	def self.test(filename,test_cases,id)
	  correct = Hash.new
    test_cases.each do |t|
      correct[t.id] = Array.new
      
      File.open("/tmp/#{id}-input-#{t.id}.dat", 'w') {|f| f.write(t.input) }
      File.open("/tmp/#{id}-output-#{t.id}.dat", 'w') {|f| f.write(t.output) }
      
      if filename.last(2) == "rb"
        `bin/timeout3 -t #{t.timeout} ruby #{filename} < /tmp/#{id}-input-#{t.id}.dat &> /tmp/#{id}-output_response-#{t.id}.dat`
      else
        `bin/timeout3 -t #{t.timeout} #{filename} < /tmp/#{id}-input-#{t.id}.dat &> /tmp/#{id}-output_response-#{t.id}.dat`
      end
      puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      puts $?.exitstatus
      # run ok
      if $?.exitstatus == 0 || $?.exitstatus == 255
        
        `diff -a /tmp/#{id}-output_response-#{t.id}.dat /tmp/#{id}-output-#{t.id}.dat`
        puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      puts $?.exitstatus
        # diff1 ok
        if $?.exitstatus == 0
          correct[t.id][0] = 0
        # diff1 fail
        else
        	`diff -abBE /tmp/#{id}-output_response-#{t.id}.dat /tmp/#{id}-output-#{t.id}.dat`

          # diff2 ok
         	if $?.exitstatus == 0
         		correct[t.id][0] = 2
          # diff2 fail
          else
            correct[t.id][0] = 3
          end
        end
      # run fail
      else
        # could be time (143) of other failure (n)
        correct[t.id][0] = $?.exitstatus

        if filename.last(2) == "rb"
          `{ bin/timeout3 -t #{t.timeout} ruby #{filename} ; } < /tmp/#{id}-input-#{t.id}.dat &> /tmp/#{id}-output_response-#{t.id}.dat`
        else
          `{ bin/timeout3 -t #{t.timeout} #{filename} ; } < /tmp/#{id}-input-#{t.id}.dat &> /tmp/#{id}-output_response-#{t.id}.dat`
        end

      end
      correct[t.id][1] = File.open("/tmp/#{id}-output_response-#{t.id}.dat", "rb") {|io| io.read}
      puts correct[t.id][0]
    end

    return correct
	end
end