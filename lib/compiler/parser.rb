class Grammars
  extend Grammar

  terminals %i[if do return let while identifier integer_constant { } ( ) + - * / & | < > = ;]

  non_terminal :statements do
    zero_or_one %i[let_statement if_statement while_statement do_statement return_statement]
  end

  non_terminal :while_statement do
    required %i[while ( expression ) { statements }]
  end

  non_terminal :let_statement do
    required %i[let var_name = expression ;]
  end

  non_terminal :if_statement do
    required %i[if]
  end

  non_terminal :return_statement do
    required %i[return]
  end

  non_terminal :do_statement do
    required %i[do]
  end

  non_terminal :expression do
    required %i[term op term]
    # optional_group %i[op term]
  end

  non_terminal :term do
    one_of %i[integer_constant var_name]
  end

  non_terminal :var_name do
    required %i[identifier]
  end

  non_terminal :op do
    one_of %i[+ - * / & | < > =]
  end
end

module Parser
  def self.call(context)
    Grammars.init(context[:tokens]).build_ast
  end
end
