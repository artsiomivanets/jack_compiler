# frozen_string_literal: true

require_relative "lib/compiler/version"

Gem::Specification.new do |spec|
  spec.name = "compiler"
  spec.version = Compiler::VERSION
  spec.authors = ["artsiomivanets"]
  spec.email = ["artem.ivanec96@gmail.com"]

  spec.summary = "summary"
  spec.description = "description"
  spec.homepage = "https://github.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
