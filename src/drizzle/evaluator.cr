require "./ast/*"
require "./object/*"

module Drizzle
  # Module containing an overloaded evaluation function that evaluates all the various node types
  class Evaluator
    # Since there are only two possible options for booleans, create them both here and reuse these instances
    @@TRUE = Object::Boolean.new true
    @@FALSE = Object::Boolean.new false
    # Same can be said for NULL
    @@NULL = Object::Null.new

    # eval method for program nodes, the starting point of any drizzle program
    def self.eval(node : AST::Program) : Object::Object
      return eval node.statements[0]
    end

    # eval method for expression statement nodes, which represent expressions on their own (e.g. an integer literal on its own)
    def self.eval(node : AST::ExpressionStatement) : Object::Object
      return eval node.expression
    end

    # eval method for prefix expression nddes
    def self.eval(node : AST::PrefixExpression) : Object::Object
      right = Evaluator.eval node.right
      return eval_prefix_expression node.operator, right
    end

    # eval method for infix expression nodes
    def self.eval(node : AST::InfixExpression) : Object::Object
      left = eval node.left
      right = eval node.right
      return eval_infix_expression node.operator, left, right
    end

    # eval method for integer literal nodes
    def self.eval(node : AST::IntegerLiteral) : Object::Object
      return Object::Integer.new node.value
    end

    # eval method for boolean literal nodes
    def self.eval(node : AST::BooleanLiteral) : Object::Object
      return convert_native_bool_to_object node.value
    end

    # temp catchall method
    def self.eval(node : AST::Node) : Object::Object
      return @@NULL
    end

    # temp handling for nil nodes since expressionstatement can have a nil expression
    def self.eval(node : Nil) : Object::Object
      return @@NULL
    end

    # non-node evaluation methods

    # eval method for prefix stuff
    def self.eval_prefix_expression(op : String, value : Object::Object) : Object::Object
      case op
      when "not"
        return eval_boolean_negation value
      when "-"
        return eval_arithmetic_negation value
      else
        return @@NULL
      end
    end

    # eval method for infix stuff
    def self.eval_infix_expression(op : String, left : Object::Object, right : Object::Object) : Object::Object
      if left.object_type == Object::INTEGER_TYPE && right.object_type == Object::INTEGER_TYPE
        return eval_arithmetic_infix_expression op, left, right
        # Because there is only two comparison operators for booleans, we can handle them here
        # These comparisons use pointer arithmetic because we can since we only have one instance of true, false or null
      elsif op == "=="
        return convert_native_bool_to_object(left == right)
      elsif op == "!="
        return convert_native_bool_to_object(left != right)
      else
        return @@NULL
      end
    end

    # eval method for handling boolean negation
    def self.eval_boolean_negation(value : Object::Object) : Object::Object
      case value
      when @@TRUE
        return @@FALSE
      when @@FALSE
        return @@TRUE
      when @@NULL
        return @@TRUE
      else
        return @@FALSE
      end
    end

    # eval method for handling arithmetic negation
    def self.eval_arithmetic_negation(value : Object::Object) : Object::Object
      if value.object_type != Object::INTEGER_TYPE
        return @@NULL
      end
      # Cast to an integer and get the value
      int_value = value.as(Object::Integer).value
      return Object::Integer.new -int_value
    end

    # eval method for handling arithmetic based infix expressions (expressions that result in a number)
    def self.eval_arithmetic_infix_expression(op : String, left : Object::Object, right : Object::Object) : Object::Object
      left_val = left.as(Object::Integer).value
      right_val = right.as(Object::Integer).value

      case op
      when "+"
        return Object::Integer.new left_val + right_val
      when "-"
        return Object::Integer.new left_val - right_val
      when "*"
        return Object::Integer.new left_val * right_val
      when "/"
        return Object::Integer.new left_val / right_val
      when "<"
        return convert_native_bool_to_object left_val < right_val
      when ">"
        return convert_native_bool_to_object left_val > right_val
      when "=="
        return convert_native_bool_to_object left_val == right_val
      when "!="
        return convert_native_bool_to_object left_val != right_val
      else
        return @@NULL
      end
    end

    # other helpers

    # convert crystal bool to drizzle object representation
    def self.convert_native_bool_to_object(value : Bool) : Object::Object
      if value
        return @@TRUE
      else
        return @@FALSE
      end
    end
  end
end
