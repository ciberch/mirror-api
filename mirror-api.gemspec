# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mirror-api/version'

Gem::Specification.new do |gem|
  gem.name          = "mirror-api"
  gem.version       = Mirror::Api::VERSION
  gem.authors       = ["Monica Wilkinson", "Drew Baumann"]
  gem.email         = ["monica@crushpath.com"]
  gem.description   = %q{Wrapper for Google Glass Mirror API v1}
  gem.summary       = %q{https://developers.google.com/glass/v1/reference/}
  gem.homepage      = "https://github.com/ciberch/mirror-api"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rake"
  gem.add_dependency "rest-client"
  gem.add_dependency "hashie"
  gem.add_dependency "json"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"
end
