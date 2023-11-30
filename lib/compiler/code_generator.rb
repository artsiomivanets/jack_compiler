module CodeGenerator
  OPERATIONS = {
    '+' => 'add'
  }
  SUBROUTINES = {
    '*' => 'Math.multiply'
  }

  def self.reset_table
    @table = {}
  end

  def self.set_table(value)
    @table = @table.merge(value)
  end

  def self.get_table(value)
    @table[value]
  end

  def self.call(context)
    reset_table
    traversed_ast = process(context)

    writer(traversed_ast).flatten.join("\n")
  end

  def self.process(context)
    traverse(context[:ast])
  end

  def self.traverse(ast)
    ast.map do |item|
      method = item[:type].to_sym
      CodeGenerator.send(method, item) if CodeGenerator.respond_to?(method)
    end.flatten.compact
  end

  def self.class_entity(item)
    set_table({ main_class: item[:body].find { |i| i[:type] == 'class_name' }.dig(:body, 0, :value) })
    traverse(item[:body])
  end

  def self.class_name(item); end

  def self.subroutine_dec(item)
    items = item[:body]
    name, params = %w[subroutine_name parameter_list].map do |k|
      items.select do |i|
        i[:type] == k
      end
    end.flatten
    {
      type: :subroutine_dec,
      name: name.dig(:body, 0, :value),
      params: params[:body],
      body: traverse(item[:body])
    }
  end

  def self.subroutine_body(item)
    body = item[:body].reject { |i| i[:type] == 'symbol' }
    traverse(body)
  end

  def self.statements(item)
    traverse(item[:body])
  end

  def self.do_statement(item)
    {
      type: :do_statement,
      body: traverse(item[:body])
    }
  end

  def self.subroutine_call(item)
    items = item[:body]
    class_name, function, params = %w[class_name subroutine_name expression_list].map do |k|
      items.select do |i|
        i[:type] == k
      end
    end.flatten
    {

      type: :subroutine_call,
      name: "#{class_name.dig(:body, 0, :value)}.#{function.dig(:body, 0, :value)}",
      params: traverse([params])
    }
  end

  def self.expression_list(item)
    traverse(item[:body])
  end

  def self.expression(item)
    ops, terms = item[:body].partition { |i| i[:type].to_sym == :op }
    op, = ops
    mapped_operation = OPERATIONS[op.dig(:body, 0, :value)]
    mapped_subroutine = SUBROUTINES[op.dig(:body, 0, :value)]
    if mapped_operation
      {
        type: :op,
        name: mapped_operation,
        params: traverse(terms)
      }
    elsif mapped_subroutine
      {
        type: :subroutine_call,
        name: mapped_subroutine,
        params: traverse(terms)
      }
    else
      traverse(terms)
    end
  end

  def self.term(item)
    if item[:body].length == 1
      {
        type: item.dig(:body, 0, :type).to_sym,
        value: item.dig(:body, 0, :value)
      }
    else
      traverse(item[:body])
    end
  end

  def self.writer(ast)
    ast.map do |i|
      case i[:type]
      when :subroutine_dec
        ["function #{get_table(:main_class)}.#{i[:name]} #{i[:params].length}"] + writer(i[:body]) + ['return']
      when :subroutine_call
        writer(i[:params]) + ["call #{i[:name]} #{i[:params].length}"]
      when :op
        writer(i[:params]) + ["#{i[:name]}"]
      when :do_statement
        writer(i[:body]) + ['pop temp 0', 'push constant 0']
      when :integer_constant
        "push constant #{i[:value]}"
      end
    end
  end
end
