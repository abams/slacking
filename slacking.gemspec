# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'slacking/version'

Gem::Specification.new do |spec|
  spec.name          = "slacking"
  spec.version       = Slacking::VERSION
  spec.authors       = ["Adam Ryan"]
  spec.email         = ["adam.g.ryan@gmail.com"]
  spec.summary       = %q{Post comments to slack as different users}
  spec.description   = %q{Create profiles you can use to post messages to slack}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ['slacking']
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
