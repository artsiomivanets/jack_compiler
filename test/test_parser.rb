# frozen_string_literal: true

require 'test_helper'
require 'json'

class TestCompiler < Minitest::Test
  def test_simple_if
    symbols = File.read('test/fixtures/simple/if.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/parser/if.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_simple_if_else
    symbols = File.read('test/fixtures/simple/if_else.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/parser/if_else.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_simple_while
    symbols = File.read('test/fixtures/simple/while.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/parser/while.json').strip
    f = Tempfile.new('aaaaa')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_simple_do
    symbols = File.read('test/fixtures/simple/do.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/simple/parser/do.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_expression_less_main
    symbols = File.read('test/fixtures/expression_less/Main.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/expression_less/parser/main.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_expression_less_square
    symbols = File.read('test/fixtures/expression_less/Square.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/expression_less/parser/square.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_expression_less_square_game
    symbols = File.read('test/fixtures/expression_less/SquareGame.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/expression_less/parser/square_game.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_with_expressions_main
    symbols = File.read('test/fixtures/with_expressions/Main.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/with_expressions/parser/main.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_with_expressions_square
    symbols = File.read('test/fixtures/with_expressions/Square.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/with_expressions/parser/square.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_with_expressions_square_game
    symbols = File.read('test/fixtures/with_expressions/SquareGame.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    expected = File.read('test/fixtures/with_expressions/parser/square_game.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(ast))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end
end
