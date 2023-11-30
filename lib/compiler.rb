# frozen_string_literal: true

require 'pry'

require_relative 'compiler/grammar'
require_relative 'compiler/version'
require_relative 'compiler/tokenizer'
require_relative 'compiler/code_generator'
require_relative 'compiler/parser'
require 'nokogiri'

class String
  # ruby mutation methods have the expectation to return self if a mutation occurred, nil otherwise. (see http://www.ruby-doc.org/core-1.9.3/String.html#method-i-gsub-21)
  def to_underscore!
    gsub!(/(.)([A-Z])/, '\1_\2')
    downcase!
  end

  def to_underscore
    dup.tap { |s| s.to_underscore! }
  end
end

module Converter
  def self.call(path)
    f = File.read(path)
    a = Nokogiri::XML(f).children

    {
      type: a.first.name.strip.to_underscore,
      body: process(a.children)
    }
  end

  def self.process(children)
    children.reject(&:text?).map do |i|
      if i.children.length == 1
        {
          type: i.name.to_underscore,
          value: i.children.text.strip
        }
      else
        {
          type: i.name.to_underscore,
          body: process(i.children)
        }
      end
    end
  end
end

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
