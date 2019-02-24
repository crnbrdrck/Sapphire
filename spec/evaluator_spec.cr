require "./spec_helper"

# Helper for testing eval function
def test_eval(input : String)
  Drizzle::Object::Object
  lexer = Drizzle::Lexer.new input
  parser = Drizzle::Parser.new lexer
  program = parser.parse_program
  return Drizzle::Evaluator.eval program
end

# helper for testing integer values
def test_integer(output, expected : Int64)
  output.nil?.should be_false
  output.not_nil!.i64?.should be_true
  output.not_nil!.to_i64.should eq expected
end

# Spec for the evaluator
describe Drizzle::Evaluator do
  it "correctly evaluates self evaluating integer expressions" do
    tests = {
      {"5", 5_i64},
      {"10", 10_i64},
    }

    tests.each do |test|
      evaluated = test_eval test[0]
      test_integer evaluated, test[1]
    end
  end
end