# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tcptop/version'

Gem::Specification.new do |spec|
  spec.name          = "tcptop"
  spec.version       = Tcptop::VERSION
  spec.authors       = ["Tony Pitluga"]
  spec.email         = ["tony.pitluga@gmail.com"]
  spec.description   = %q{A monitoring tool for TCP connections}
  spec.summary       = %q{A monitoring tool for TCP connections}
  spec.homepage      = "http://github.com/pitluga/tcptop"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "raindrops", "~> 0.12.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
