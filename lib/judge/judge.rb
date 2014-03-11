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

  def self.exec_file(filename, lang, timeout, input_file, output_file)

    if lang == "rb"
      filename = "ruby " + filename
    end
    
    if Rails.env == "production"
      user_command = "ssh exec@localhost"
    else
      user_command = ""
    end

    Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    `bin/timeout3 -t #{timeout} #{user_command} #{filename} < #{input_file} > #{output_file}`
    Rails.logger.info "bin/timeout3 -t #{timeout} #{user_command} #{filename} < #{input_file} > #{output_file}"
    Rails.logger.info $?.exitstatus
  end

  def self.diff(ignore_presentation,file1,file2)
    if ignore_presentation
      `diff -abBE #{file1} #{file2}`
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      Rails.logger.info "diff -abBE #{file1} #{file2}"
      Rails.logger.info $?.exitstatus
    else
      `diff -a #{output_response_file} #{output_file}`
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      Rails.logger.info "diff -a #{file1} #{file2}"
      Rails.logger.info $?.exitstatus
    end
  end

  def self.numdiff(file1,file2)
    `numdiff -I --absolute-tolerance=0.00001 #{file1} #{file2}`
    Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    Rails.logger.info "numdiff --absolute-tolerance=0.00001 -I #{file1} #{file2}"
    Rails.logger.info $?.exitstatus
  end

  def self.test(lang,filename,test_cases,id)
    correct = Hash.new
    test_cases.each do |t|
      correct[t.id] = Array.new
      correct[t.id][3] = Array.new
      correct[t.id][2] = Array.new
      correct[t.id][1] = Array.new

      input = t.input.split(CASE_TEST_END)
      output = t.output.split(CASE_TEST_END)

      n = input.length-1
      n = 0 if n < 0

      for i in 0..n
        input_file = "/tmp/#{id}-input-#{t.id}-#{i}.dat"
        output_file = "/tmp/#{id}-output-#{t.id}-#{i}.dat"
        output_response_file = "/tmp/#{id}-output_response-#{t.id}-#{i}.dat"

        File.open(input_file, 'w') {|f| f.write(input[i]) }
        File.open(output_file, 'w') {|f| f.write(output[i]) }

        exec_file(filename,lang,t.timeout,input_file,output_response_file)
        
        # run ok
        if $?.exitstatus == 0 || $?.exitstatus == 255 || lang == "c"

          if t.ignore_presentation

            diff(true,output_response_file,output_file)

            # diff ok
            if $?.exitstatus == 0
              correct[t.id][2][i] = 0
            # diff fail
            else

              numdiff(output_response_file,output_file)
              
              # numdiff ok
              if $?.exitstatus == 0
                correct[t.id][2][i] = 0
              # numdiff fail
              else
                correct[t.id][2][i] = 3
              end
            end
          else
            diff(false,output_response_file,output_file)

            # diff1 ok
            if $?.exitstatus == 0
              correct[t.id][2][i] = 0
            # diff1 fail
            else
              diff(true,output_response_file,output_file)

              # diff2 ok - presentation error
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
          
          # if it's not time, then save the output
          #if correct[t.id][2][i] != 143
          #  correct[t.id][1][i] = File.open(output_response_file, "rb") {|io| io.read}
          #end
        end
        correct[t.id][3][i] = File.open(output_response_file, "rb") {|io| io.read}
      end

      # get the first fail to present to the user
      correct[t.id][0] = 0
      for i in 0..n
        if correct[t.id][2][i] != 0
          correct[t.id][0] = correct[t.id][2][i]
          correct[t.id][1][0] = input[i]
          correct[t.id][1][1] = output[i]
          correct[t.id][1][2] = correct[t.id][3][i]
          break
        end
      end

      # print the final result for the test case
      Rails.logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> Final"
      Rails.logger.info correct[t.id][0]

      # kill all the proccess that still may be open
      if Rails.env == "production"
        `echo "poi890poi" | sudo -S pkill -f #{filename} -u exec`
      end
    end

    return correct
  end
end