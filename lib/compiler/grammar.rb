module Grammar
  def init(tokens)
    Grammar.tokens = tokens
    self
  end

  def build_ast
    process([])
  end

  def process(ast)
    non_terminals = Grammars.grammars.values.select { |i| i[:rule] }.map { |i| i[:value] }

    ast + non_terminals.map(&:call).compact
  end

  def self.take_token!
    first, *rest = @tokens
    @tokens = rest
    first
  end

  def self.get_token
    token, = tokens
    token
  end

  def self.tokens=(tokens)
    @tokens = tokens
  end

  def self.tokens
    @tokens
  end

  def non_terminal(name, &block)
    @grammars ||= {}

    @grammars[name] = {
      value: NonTerminal.new(name),
      rule: Rule.new.instance_eval(&block)
    }
  end

  def terminals(methods)
    @grammars ||= {}
    methods.each do |m|
      @grammars[m] = {
        value: Terminal.new(m)
      }
    end
  end

  def grammars
    @grammars
  end

  class Terminal
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def call
      raise unless Grammar.get_token.values.include?(name.to_s)

      Grammar.take_token!
    end
  end

  class NonTerminal
    attr_accessor :name

    def initialize(name)
      @name = name
    end

    def rule
      Grammars.grammars[name][:rule]
    end

    def call
      return unless Grammar.get_token

      binding.pry if Grammar.get_token[:value].to_s == 'do'
      result = rule.call
      binding.pry if Grammar.get_token[:value].to_s == 'do'
      return if !result && !rule.optional?

      {
        type: name.to_s,
        body: result
      }
    end
  end

  class ZeroOrMore
    def initialize(methods)
      @methods = methods
    end

    def call
      @methods.filter_map do |i|
        i.call
      rescue StandardError => e
      end
    end
  end

  class Required
    def initialize(methods)
      @methods = methods
    end

    def call
      @methods.map(&:call).compact
    rescue StandardError => e
    end
  end

  class OneOf
    def initialize(methods)
      @methods = methods
    end

    def call
      @methods.lazy.filter_map do |i|
        i.call
      rescue StandardError => e
      end.first
    end
  end

  class Rule
    attr_accessor :rules

    def initialize
      @methods = []
      @rules = []
      @optional = false
    end

    def call
      binding.pry if Grammar.get_token[:value].to_s == 'do'
      result = @rules.map(&:call).flatten.compact
      binding.pry if Grammar.get_token[:value].to_s == 'do'
      result.empty? ? nil : result
    end

    def prepare(methods)
      methods.map { |m| Grammars.grammars[m]&.dig(:value) || NonTerminal.new(m) }
    end

    def optional(&block)
      @optional = true
      instance_eval(&block)
    end

    def optional?
      @optional
    end

    def zero_or_more(methods)
      @rules.push ZeroOrMore.new(prepare(methods))
      self
    end

    def required(methods = [], &block)
      if block_given?
        @rules.push Required.new(Rule.new.instance_eval(&block).rules)
      else
        @rules.push Required.new(prepare(methods))
      end
      self
    end

    def one_of(methods = [], &block)
      if block_given?
        @rules.push OneOf.new(Rule.new.instance_eval(&block).rules)
      else
        @rules.push OneOf.new(prepare(methods))
      end
      self
    end
  end
end
