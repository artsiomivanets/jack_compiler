# frozen_string_literal: true

require "test_helper"
require "gyoku"
require "nokogiri"

class TestCompiler < Minitest::Test
  def test_tokenize_simple_if
    symbols = File.read("test/fixtures/simple/if.jack")
    tokens = Tokenizer.call({ symbols: symbols, as: "key-value" })
    result = Nokogiri::XML(Gyoku.xml({ tokens: tokens }, { unwrap: true })).to_xhtml
    expected = File.read("test/fixtures/simple/tokenizer_if.xml")
    assert_equal(expected, result)
  end

  def test_parser_simple_if
    symbols = File.read("test/fixtures/simple/while.jack")
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens, as: "nand2tetris" })
    result = Nokogiri::XML(Gyoku.xml({ ast: ast }, { unwrap: true })).to_xhtml
    expected = File.read("test/fixtures/simple/while_parser.xml")
    assert_equal(expected, result)
  end
end
