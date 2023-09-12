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
end
