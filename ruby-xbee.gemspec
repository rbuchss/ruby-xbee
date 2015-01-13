# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xbee/version'

Gem::Specification.new do |s|
  s.name          = 'ruby-xbee'
  s.version       = XBee::Version::STRING
  s.authors       = ['Landon Cox', 'Mike Ashmore', 'Sten Feldman', 'Russ Buchanan']
  s.email         = %w(exile@chamber.ee)
  s.date          = '2014-03-09'
  s.description   = 'A Ruby XBee gem'
  s.summary       = 'Controlling an XBee module from Ruby either in AT (Transparent) or API mode. ' \
    'Both Series 1 and Series 2 radio modules are supported.'
  s.homepage      = 'http://github.com/exsilium/ruby-xbee'
  s.licenses      = 'AGPL'

  s.platform = Gem::Platform::RUBY
  s.rubygems_version = '1.3.1'
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = %w(lib)

  s.has_rdoc = true
  s.extra_rdoc_files = %w(LICENSE agpl.txt README.rdoc)
  s.rdoc_options = %w(--charset=UTF-8)

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'simplecov', '~> 0.8'
  s.add_development_dependency 'reek', '~> 1.5'

  s.add_runtime_dependency 'serialport', '~> 1.1'
  s.add_runtime_dependency 'require_all', '~> 1.3'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.add_runtime_dependency 'highline', '~> 1.6'
end
