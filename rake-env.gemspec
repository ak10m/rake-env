# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake/env/version'

Gem::Specification.new do |spec|
  spec.name          = "rake-env"
  spec.version       = Rake::Env::VERSION
  spec.authors       = ["Akio Morimoto"]
  spec.email         = ["akio.morimoto@airits.jp"]
  spec.summary       = %q{Rake extension for sharing variables between tasks}
  spec.homepage      = "https://github.com/ak10m/rake-env"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", "~> 10.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "minitest", "~> 5.0"
end
