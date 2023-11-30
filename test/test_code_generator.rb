require 'test_helper'
require 'json'

class TestCodeGenerator < Minitest::Test
  def test_seven
    symbols = File.read('test/fixtures/code_generator/seven/Main.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    vm_code = CodeGenerator.call({ ast: ast })
    expected = File.read('test/fixtures/code_generator/seven/Main.vm').strip
    assert_equal(expected, vm_code)
  end

  def test_convert_to_bin
    symbols = File.read('test/fixtures/code_generator/convert_to_bin/Main.jack')
    tokens = Tokenizer.call({ symbols: symbols })
    ast = Parser.call({ tokens: tokens })
    vm_code = CodeGenerator.call({ ast: ast })
    expected = File.read('test/fixtures/code_generator/convert_to_bin/Main.vm').strip
    assert_equal(expected, vm_code)
  end
end
