# frozen_string_literal: true

require 'test_helper'
require 'json'

class TestCompiler < Minitest::Test
  def test_tokenize_simple_if
    symbols = File.read('test/fixtures/simple/if.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    expected = File.read('test/fixtures/simple/tokenizer_if.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_parser_simple_if
    symbols = File.read('test/fixtures/simple/if.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/if_parser.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_parser_simple_if_else
    symbols = File.read('test/fixtures/simple/if_else.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/if_else_parser.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_parser_simple_while
    symbols = File.read('test/fixtures/simple/while.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/while_parser.json').strip
    f = Tempfile.new('aaaaa')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_tokenize_expression_less_main
    symbols = File.read('test/fixtures/expression_less/Main.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    expected = File.read('test/fixtures/expression_less/main_t.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_parser_simple_do
    symbols = File.read('test/fixtures/simple/do.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/do_parser.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_parser_expression_less_main
    symbols = File.read('test/fixtures/expression_less/Main.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/expression_less/main.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end
end
