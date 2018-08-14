# agreement-design.gemspec
# TODO - split the gem for schema design from the one containing agreement models
Gem::Specification.new do |spec|
  spec.name          = "agreement-design-prototype"
  spec.version       = "0.0.3"
  spec.authors       = ["CCS"]
  spec.homepage      = 'https://github.com/Crown-Commercial-Service/cmp-design-prototype/agreement-design'
  spec.email         = ["rubygems@humphries.tech"]
  spec.description   = %q{A prototype of techniques to manage agreement specifications.}
  spec.summary       = %q{Agreement prototype .}
  spec.license       = "MIT"

  spec.files         = Dir["./**/*"]
  spec.executables   = Dir["./bin/*"]
  spec.test_files    = Dir["./test/**/*"]
  spec.require_paths = ["src", "model"]

  spec.add_development_dependency "rake", "12.3.0"
end