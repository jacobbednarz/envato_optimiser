# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'envato_optimiser/version'

Gem::Specification.new do |spec|
  spec.name          = 'envato_optimiser'
  spec.version       = EnvatoOptimiser::VERSION
  spec.authors       = ['Jacob Bednarz']
  spec.email         = ['jacob.bednarz@gmail.com']

  spec.summary       = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/jacobbednarz/envato_optimiser'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.6.7'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
