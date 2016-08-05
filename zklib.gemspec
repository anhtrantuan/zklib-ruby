# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zklib/version'

Gem::Specification.new do |spec|
  spec.name          = "zklib"
  spec.version       = Zklib::VERSION
  spec.authors       = ["Anh Tran"]
  spec.email         = ["anhtrantuan.hcmc@gmail.com"]

  spec.summary       = %q{Attendance machine client written in Ruby.}
  spec.description   = %q{A Ruby client to manage attendance machine. This is a port from a Node.js counterpart https://github.com/bulentv/js_zklib}
  spec.homepage      = "https://github.com/anhtrantuan/zklib-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bindata", "~> 2.3"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "byebug", "~> 9.0"
end
