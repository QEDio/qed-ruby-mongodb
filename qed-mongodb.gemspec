# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "qed-mongodb/version"

Gem::Specification.new do |s|
  s.name        = "qed-mongodb"
  s.version     = Qed::Mongodb::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Johannes Kaefer"]
  s.email       = ["jak4@qed.io"]
  s.homepage    = ""
  s.summary     = %q{Mongodb MapReduce Layer}
  s.description = %q{Provide an encapsulated way to generate MapReduce queries from a given set of parameters}

  s.rubyforge_project = "qed-mongodb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'mongoid'
  s.add_development_dependency 'yajl-ruby'
  s.add_development_dependency 'activesupport', '~> 3.1.1'
  s.add_development_dependency 'i18n'

  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'turn'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'spork-testunit'
  s.add_development_dependency 'simplecov'
end
