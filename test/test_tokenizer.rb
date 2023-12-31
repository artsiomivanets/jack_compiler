# frozen_string_literal: true

require 'test_helper'
require 'json'

class TestTokenizer < Minitest::Test
  def test_simple_if
    symbols = File.read('test/fixtures/simple/if.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    expected = File.read('test/fixtures/simple/tokenizer/if.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
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
    expected = File.read('test/fixtures/expression_less/tokenizer/main.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
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
    expected = File.read('test/fixtures/expression_less/tokenizer/square.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
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
    expected = File.read('test/fixtures/expression_less/tokenizer/square_game.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_with_expression_main
    symbols = File.read('test/fixtures/with_expressions/Main.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    expected = File.read('test/fixtures/with_expressions/tokenizer/main.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_with_expression_square
    symbols = File.read('test/fixtures/with_expressions/Square.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    expected = File.read('test/fixtures/with_expressions/tokenizer/square.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end

  def test_with_expression_square_game
    symbols = File.read('test/fixtures/with_expressions/SquareGame.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    expected = File.read('test/fixtures/with_expressions/tokenizer/square_game.json').strip
    f = Tempfile.new('foo')
    f.write(JSON.pretty_generate(tokens))
    f.rewind
    actual = f.read
    p = diff(expected, actual)
    puts p unless p.include?('No visible difference in the String')
    assert { p.include?('No visible difference in the String') }
    f.close
    f.unlink
  end
end
