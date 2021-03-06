module Drizzle
  # Enum of the various types of Tokens in the Drizzle language.
  # This enum is used for the creation of `Token` instances, and will use its helper methods to help in the parsing stages also.
  enum TokenType
    # Special Tokens

    # Token is generated from a string that Drizzle does not recognise
    ILLEGAL
    # End of line token (usually ignored except for certain cases)
    EOL
    # End of file token
    EOF

    # Identifiers / Literals

    # Name of variable, function, type, etc
    IDENTIFIER
    # Integer literal
    INTEGER
    # String literal
    STRING

    # Operators

    # Assignment operator for assigning value to a variable
    ASSIGN
    # Return type operator for specifying a functions return type
    RETURN_TYPE
    # Addition operator for adding two values together
    PLUS
    # Subtraction operator for subtracting numbers.
    # Also the unary negation operator.
    MINUS
    # Star operator used for multiplication, among other potential stuff later on too
    ASTERISK
    # Slash operator used for division
    SLASH

    # Logical Operators

    # Less than logical operator
    LT
    # Greater than logical operator
    GT
    # Equality logical operator
    EQ
    # Inequality logical operator
    NOT_EQ
    # Less than or equal to
    LT_EQ
    # Greater than or equal to
    GT_EQ

    # Delimiters

    # Separating of items in a data structure / parameter list / etc.
    COMMA
    # Separating of identifier from type in the case of variables and parameters
    COLON
    # Opening of parameter lists and tuples, and of general brackets
    LEFT_PAREN
    # Closing of parameter lists and tuples, and of general brackets
    RIGHT_PAREN
    # Opening of code blocks i.e. functions, as well as opening of set and dict literals
    LEFT_BRACE
    # CLosing of code blocks i.e. functions, as well as closing of set and dict literals
    RIGHT_BRACE
    # Opening of arrays and indexing operations
    LEFT_BRACKET
    # Closing of arrays and indexing operations
    RIGHT_BRACKET

    # Language keywords

    # Declaration of a variable
    LET
    # Definition of a function
    FUNCTION
    # Return value from a function
    RETURN
    # Conditional statement
    IF
    # Elsif
    ELSIF
    # Else
    ELSE
    # Logical negation
    NOT
    # True
    TRUE
    # False
    FALSE
  end

  # Hash of all keywords in Drizzle to their corresponding TokenTypes.
  #
  # Used as part of the `Lexer`'s process of generating a new Token in order to determine whether a read string of characters is a keyword or not.
  Keywords = {
    "let"    => TokenType::LET,
    "def"    => TokenType::FUNCTION,
    "return" => TokenType::RETURN,
    "if"     => TokenType::IF,
    "elsif"  => TokenType::ELSIF,
    "else"   => TokenType::ELSE,
    "not"    => TokenType::NOT,
    "true"   => TokenType::TRUE,
    "false"  => TokenType::FALSE,
  }

  # A Token is generated by the `Lexer` as it reads in Drizzle source code.
  #
  # Tokens are then used to generate an Abstract Syntax Tree (AST) which can then be used to actually make the language do things.
  class Token
    @token_type : TokenType
    @literal : String
    # Production stuff
    @file_name : String
    @line_num : Int32
    @char_num : Int32

    # Create an instance of a Token.
    def initialize(@token_type : TokenType, @literal : String, @file_name : String = "<stdin>", @line_num : Int32 = 0, @char_num : Int32 = 0)
    end

    # Convert the Token instance into a String representation.
    def to_s : String
      return "Token(#{@token_type}, #{@literal}) from #{@file_name}, line #{@line_num}, char #{@char_num}"
    end

    # The `TokenType` that represents the type of this Token instance
    getter token_type
    # The literal value that was used to generate this Token instance
    getter literal
    # The name of the file this Token was generated from
    getter file_name
    # The number of the line in the file that this Token was generated from
    getter line_num
    # The number of the initial character in the string that generated this Token
    getter char_num
  end
end
