require "./ast/*"
require "./lexer"
require "./token"

module Drizzle
  # A Parser reads in the tokens generated by a `Lexer` and constructs an Abstract Syntax Tree (AST) built from what it finds.
  class Parser
    @lexer : Lexer
    @current : Token | Nil = nil
    @peek : Token | Nil = nil

    def initialize(@lexer : Lexer)
      # Read the first two tokens to set up curr and peek variables
      self.next_token
      self.next_token
    end

    # Update the `@current` and `@peek` pointers contained in the Parser instance to the next token generated from the `Lexer`
    def next_token
      @current = @peek
      @peek = @lexer.get_next_token
    end

    # Parse a program and build a program node from it
    def parse_program
    end

    # Getters and setters (writing them myself because I know the tokens will never be nil)

    # The token that is currently being inspected by the parser
    def current : Token
      return @current.not_nil!
    end

    # A pointer to the next token coming up in the stream.
    # This is used to help guide what kind of node will be built from `@current`
    def peek : Token
      return @peek.not_nil!
    end
  end
end
