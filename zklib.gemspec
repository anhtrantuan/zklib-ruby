# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zklib/version'

Gem::Specification.new do |spec|
  spec.name     = 'zklib'
  spec.version  = Zklib::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.license  = 'MIT'

  spec.summary     = 'Attendance machine client in Ruby'
  spec.email       = 'anhtrantuan.hcmc@gmail.com'
  spec.homepage    = 'https://github.com/anhtrantuan/zklib-ruby'
  spec.description = 'Attendance machine client in Ruby'
  spec.authors     = ['Anh Tran']

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bindata', '~> 2.3'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'byebug', '~> 9.0'
end
