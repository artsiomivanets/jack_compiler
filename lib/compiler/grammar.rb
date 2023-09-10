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

    ast + non_terminals.map(&:call).compact.reject { |i| i[:body].empty? }
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
      rule: Rule.new(name).instance_eval(&block)
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

  def declare_terminal_rule(name, &block)
    @grammars[name] = {
      value: Terminal.new(name, &block)
    }
  end

  def grammars
    @grammars
  end

  class Terminal
    attr_accessor :name, :custom_rule

    def initialize(name, &block)
      @name = name
      return unless block_given?

      @custom_rule = block
    end

    def call
      if custom_rule
        raise unless custom_rule.call(Grammar.get_token)
      else
        raise unless Grammar.get_token.values.include?(name.to_s)
      end

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

      begin
        result = rule.call
      rescue StandardError
        result = nil
      end

      return unless result

      {
        type: name.to_s,
        body: result
      }
    end
  end

  class ZeroOrMore
    attr_accessor :name, :methods

    def initialize(name, methods)
      @name = name
      @methods = methods
    end

    def call
      r = @methods.filter_map do |i|
        i.call
      rescue StandardError => e
      end
      return [] if r&.empty?

      r + call
    end
  end

  class Required
    attr_accessor :name, :methods

    def initialize(name, methods)
      @name = name
      @methods = methods
    end

    def call
      @methods.map do |i|
        r = i.call
        raise unless r

        r
      end
    end
  end

  class Optional
    attr_accessor :name, :methods

    def initialize(name, methods)
      @name = name
      @methods = methods
    end

    def call
      @methods.map(&:call).compact
    rescue StandardError => e
      []
    end
  end

  class OneOf
    attr_accessor :name, :methods

    def initialize(name, methods)
      @name = name
      @methods = methods
    end

    def call
      result = @methods.lazy.filter_map do |i|
        a = transaction do
          i.call
        end
        a
      rescue StandardError => e
      end.first
      raise unless result

      result
    end

    def transaction
      tokens = Grammar.tokens
      r = yield
      Grammar.tokens = tokens if !r || r.empty?
      r
    rescue StandardError => e
      Grammar.tokens = tokens
      nil
    end
  end

  class Rule
    attr_accessor :rules, :name

    def initialize(name)
      @name = name
      @methods = []
      @rules = []
    end

    def call
      @rules.map(&:call).flatten.compact
    end

    def prepare(methods)
      methods.map { |m| Grammars.grammars[m]&.dig(:value) || NonTerminal.new(m) }
    end

    def optional(&block)
      @rules.push Optional.new(name, Rule.new(name).instance_eval(&block).rules)
      self
    end

    def zero_or_more(methods)
      @rules.push ZeroOrMore.new(name, prepare(methods))
      self
    end

    def required(methods = [], &block)
      if block_given?
        @rules.push Required.new(name, Rule.new(name).instance_eval(&block).rules)
      else
        @rules.push Required.new(name, prepare(methods))
      end
      self
    end

    def one_of(methods = [], &block)
      if block_given?
        @rules.push OneOf.new(name, Rule.new(name).instance_eval(&block).rules)
      else
        @rules.push OneOf.new(name, prepare(methods))
      end
      self
    end
  end
end
