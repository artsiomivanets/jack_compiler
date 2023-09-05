module Tokenizer
  KEYWORDS = %w[class construction method field static
                var int char boolean void true false null this
                let do if else while return]

  SYMBOLS = %w[{ } ( ) [ ] . , ; + - * / & | < > = ~]

  def self.process(c, acc)
    case acc[:state]
    when "common"
      return acc if [" ", "\n"].include?(c)

      return process(c, acc.merge(state: "comment")) if c == "/"

      return process(c, acc.merge(state: "symbol")) if SYMBOLS.include?(c)

      return process(c, acc.merge(state: "integer_constant")) if c.match(/[0-9]/)

      return acc.merge(state: "string_constant") if c == '"'

      process(c, acc.merge(state: "word"))
    when "comment"
      return acc unless c == "\n"

      process(c, acc.merge(state: "common"))
    when "symbol"
      word = { type: :symbol, value: c }
      acc.merge({ state: "common", word: "", words: acc[:words] + [word] })
    when "integer_constant"
      if c.match(/[0-9]/)
        acc.merge(word: acc[:word] + c)
      else
        word = { type: :integer_constant, value: acc[:word] }
        process(c, acc.merge(state: "common", word: "", words: acc[:words] + [word]))
      end
    when "string_constant"
      if c == '"'
        word = { type: :string_constant, value: acc[:word] }
        acc.merge(state: "common", word: "", words: acc[:words] + [word])
      else
        acc.merge(word: acc[:word] + c)
      end
    when "word"
      if c.match(/\w/)
        acc.merge(word: acc[:word] + c)
      else
        type = KEYWORDS.include?(acc[:word]) ? :keyword : :identifier
        word = { type: type, value: acc[:word] }
        acc.merge(state: "common", word: "", words: acc[:words] + [word])
      end
    end
  end

  def self.call(context)
    result = context[:symbols].split("").reduce({
                                                  state: "common",
                                                  words: [],
                                                  word: ""
                                                }) do |acc, c|
      process(c, acc)
    end

    return result[:words] unless context[:as] == "key-value"

    result[:words].map { |i| { i[:type] => i[:value] } }
  end
end
