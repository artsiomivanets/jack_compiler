# frozen_string_literal: true

require 'test_helper'
require 'json'

class TestCompiler < Minitest::Test
  def test_tokenize_simple_if
    symbols = File.read('test/fixtures/simple/if.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    expected = File.read('test/fixtures/simple/tokenizer_if.json')
    assert_equal(JSON.parse(expected, symbolize_names: true), tokens)
  end

  def test_parser_simple_if
    symbols = File.read('test/fixtures/simple/while.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/while_parser.json')
    assert_equal(JSON.parse(expected, symbolize_names: true), ast)
  end
end
