# frozen_string_literal: true

require "pry"

require_relative "compiler/grammar"
require_relative "compiler/version"
require_relative "compiler/tokenizer"
require_relative "compiler/parser"

module Compiler
  def self.call(path)
    symbols = if File.directory?(path)
                prepare_dir_lines(path)
              else
                File.read(path)
              end

    context = { path: path, symbols: symbols }

    tokens = Tokenizer.call(context)
    ast = Parser.call(context.merge(tokens: tokens))
  end
end
