# -*- encoding: utf-8 -*-
require File.expand_path('../lib/versioned_seeds/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Simon COURTOIS"]
  gem.email         = ["scourtois@cubyx.fr"]
  gem.description   = %q{Manage your seed scripts by versioning them}
  gem.summary       = %q{Versioned Seeds provides a very simple way to manage your seed scripts by versioning them. It provides rake tasks to load them.}
  gem.homepage      = "http://github.com/simonc/versioned_seeds"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "versioned_seeds"
  gem.require_paths = ["lib"]
  gem.version       = VersionedSeeds::VERSION

  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '>= 2'
  gem.add_development_dependency 'rails', '>= 3'
end
