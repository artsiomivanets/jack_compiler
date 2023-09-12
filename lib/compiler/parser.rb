class Grammars
  extend Grammar

  terminals %i[if else class int char boolean
               constructor function method
               void static field
               var true false null this
               do return let while identifier integer_constant
               string_constant
               { } ( ) + - * / & | < > = , . ;]

  declare_terminal_rule :class_identifier do |token|
    token[:type] == 'identifier' && /^[A-Z]/.match(token[:value])
  end

  non_terminal :statements do
    zero_or_more %i[let_statement if_statement while_statement do_statement return_statement]
  end

  non_terminal :while_statement do
    required %i[while ( expression ) { statements }]
  end

  non_terminal :let_statement do
    required %i[let var_name = expression ;]
  end

  non_terminal :if_statement do
    required %i[if ( expression ) { statements }]
    optional do
      required %i[else { statements }]
    end
  end

  non_terminal :return_statement do
    required %i[return]
    required %i[;]
  end

  non_terminal :do_statement do
    required %i[do subroutine_call ;]
  end

  non_terminal :class_entity do
    required %i[class class_name {]
    zero_or_more %i[class_var_dec]
    zero_or_more %i[subroutine_dec]
    required %i[}]
  end

  non_terminal :type do
    one_of %i[int char boolean class_name]
  end

  non_terminal :class_var_dec do
    one_of %i[static field]
    required %i[type var_name]
    zero_or_more do
      required %i[, var_name]
    end
    required %i[;]
  end

  non_terminal :subroutine_dec do
    one_of %i[constructor function method]
    one_of %i[void type]
    required %i[subroutine_name ( parameter_list ) subroutine_body]
  end

  non_terminal :parameter_list do
    optional do
      required %i[type var_name]
      zero_or_more do
        required %i[, type var_name]
      end
    end
  end

  non_terminal :subroutine_body do
    required %i[{]
    zero_or_more %i[var_dec]
    required %i[statements]
    required %i[}]
  end

  non_terminal :var_dec do
    required %i[var type var_name]
    zero_or_more do
      required %i[, var_name]
    end
    required %i[;]
  end

  non_terminal :class_name do
    required %i[class_identifier]
  end

  non_terminal :subroutine_name do
    required %i[identifier]
  end

  non_terminal :var_name do
    required %i[identifier]
  end

  non_terminal :expression do
    required %i[term]
    optional do
      required %i[op term]
    end
  end

  non_terminal :term do
    one_of %i[integer_constant var_name string_constant]
  end

  non_terminal :subroutine_call do
    one_of do
      required %i[subroutine_name ( expression_list )]
      required do
        one_of %i[class_name var_name]
        required %i[.]
        required %i[subroutine_name ( expression_list )]
      end
    end
  end

  non_terminal :expression_list do
    optional do
      required %i[expression]
      zero_or_more do
        required %i[, expression]
      end
    end
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
