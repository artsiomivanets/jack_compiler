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

    ast + non_terminals.map(&:execute).compact
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
      rule: Rule.instance_eval(&block)
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

    def execute
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

    def execute
      return unless Grammar.get_token

      result = rule.call
      return unless result

      {
        type: name.to_s,
        body: result
      }
    end
  end

  class Rule
    def self.prepare(methods)
      methods.map { |m| Grammars.grammars[m]&.dig(:value) || NonTerminal.new(m) }
    end

    def self.zero_or_one(methods)
      methods = prepare(methods)
      proc do
        methods.filter_map do |i|
          i.execute
        rescue StandardError => e
        end.first
      end
    end

    def self.required(methods)
      methods = prepare(methods)
      proc do
        methods.map(&:execute).compact
      rescue StandardError => e
      end
    end

    def self.optional_group(methods)
      required(methods)
    end

    def self.one_of(methods)
      methods = prepare(methods)
      proc do
        methods.filter_map do |i|
          i.execute
        rescue StandardError => e
        end.first
      end
    end
  end
end
