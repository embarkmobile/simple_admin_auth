# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_admin_auth/version'

Gem::Specification.new do |gem|
  gem.name          = "simple_admin_auth"
  gem.version       = SimpleAdminAuth::VERSION
  gem.authors       = ["Ralf Kistner"]
  gem.email         = ["ralf@embarkmobile.com"]
  gem.description   = %q{Add simple admin authentication to any Rails application, using Google Apps for authentication.}
  gem.summary       = %q{Simple admin authentication using Google Apps}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'omniauth'
  gem.add_dependency 'sinatra'
end
