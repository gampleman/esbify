# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ESBify/version"

Gem::Specification.new do |s|
  s.name        = "ESBify"
  s.version     = ESBify::VERSION
  s.authors     = ["Jakub Hampl"]
  s.email       = ["honitom@seznam.cz"]
  s.homepage    = "https://github.com/gampleman/esbify"
  s.summary     = %q{Generates proper XML files for the ESB framework from a DSL.}
  s.description = %q{Generates proper XML files for the ESB framework from a DSL.}

  s.rubyforge_project = "ESBify"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_runtime_dependency "builder"
  s.add_runtime_dependency "erubis"
end
