require 'rubygems'
require 'math_engine'

module MathEvaluate
  module Expression
    def self.eql?(exp_a, exp_b, options = {})
      begin
        variables = options[:variables] ? options[:variables] : []
        variables_with_values = self.generate_values(variables)

        #puts "exp_a #{exp_a}"
        #puts "exp_b #{exp_b}"

        a = self.evaluate(exp_a.to_s, variables_with_values)
        b = self.evaluate(exp_b.to_s, variables_with_values)

        #puts "a: #{a}"
        #puts "b: #{b}"

        #precission of 6 decimal digits precision
        diff = (a - b).abs
        return  diff < 0.000001
      rescue => e
        puts "Error: #{e}"
        return false
      end
    end

    def self.eql_with_eql_sinal?(exp_a, exp_b, options = {})
      left_exp_a, right_exp_a = exp_a.split('=')
      left_exp_b, right_exp_b = exp_b.split('=')

      return ( self.eql?(left_exp_a, left_exp_b, options) &&
               self.eql?(right_exp_a, right_exp_b, options) ) ||
             ( self.eql?(left_exp_a, right_exp_b, options) &&
               self.eql?(right_exp_a, left_exp_b, options) )


    end

    def self.eql_with_many_answers?(exp_a, exp_b, options = {})
      exps_a = exp_a.split(';')
      exps_b = exp_b.split(';')

      equal = true

      begin
        exps_a.each_with_index do |el, index|
          equal = self.eql?(el, exps_b[index], options)
          return false unless equal
        end
        return equal
      rescue => e
        puts "Error: #{e}"
        return false
      end
    end

    def self.evaluate(exp, variables_with_values)
      engine = MathEngine::MathEngine.new
      variables_with_values.each do |key, value|
        engine.evaluate("#{key} = #{value}")
      end
      engine.evaluate(exp)
    end

    def self.generate_values(variables)
      vwv = {}
      variables.each do |v|
        vwv[v] = rand()
      end
      vwv
    end
  end
end
