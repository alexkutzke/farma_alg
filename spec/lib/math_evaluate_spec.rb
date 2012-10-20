require File.expand_path("../../../lib/math/math_evaluate", __FILE__)

describe "math evalute" do

  it "the params are equals the should be true" do
    MathEvaluate::Expression.eql?('2', '4/2').should be_true
  end

  it "the params are equals the should be true" do
    MathEvaluate::Expression.eql?('6.2', '12.4/2').should be_true
  end

  it "the params are equals the should be true" do
    MathEvaluate::Expression.eql?('3*3', '18/2').should be_true
  end

  it "the params are equals the should be true" do
    MathEvaluate::Expression.eql?('2', '2').should be_true
  end

  it "the params are equals the should be true" do
    MathEvaluate::Expression.eql?('6.2', '6.1 + 0.1').should be_true
  end

  describe "test with variavles" do
    it "have should evalulate equals exp as true" do
      options = {variables: ['x']}
      MathEvaluate::Expression.eql?('x + 4/2', 'x + 2', options).should be_true
    end
    it "have should evalulate diff expressions as false" do
      options = {variables: ['x']}
      MathEvaluate::Expression.eql?('x + 4', 'x + 2', options).should be_false
    end
  end

  describe 'wrong answers' do
    it "the params are not equals the should be false" do
      MathEvaluate::Expression.eql?('1000', '100 + 0.0').should be_false
    end

    it "shoul return false if empty string is sent" do
      MathEvaluate::Expression.eql?('', '100 + 0.0').should be_false
    end
  end

  describe 'show accept more the one answer separate by ;' do
    it "10;10 should be equal 10;10" do
      MathEvaluate::Expression.eql_with_many_answers?('10;10', '10;10').should be_true
    end

    it "10+x;x+2*5 should be equal 10+x;x+2*5 " do
      options = {variables: ['x']}
      MathEvaluate::Expression.eql_with_many_answers?('10+x;x+2*5', '10+x;x+2*5', options).should be_true
    end

    it "10+x;x+2*5 should not be equal 10+x;x+2*6 " do
      options = {variables: ['x']}
      MathEvaluate::Expression.eql_with_many_answers?('10+x;x+2*5', '10+x;x+2*6', options).should be_false
    end
  end

end
