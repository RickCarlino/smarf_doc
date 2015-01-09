$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.authors = ['Rick Carlino']
  s.description = "Write API documentation using existing controller tests."
  s.email = 'rick.carlino@gmail.com'
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/RickCarlino/smarf_doc'
  s.license = 'MIT'
  s.name = 'smarf_doc'
  s.require_paths = ['lib']
  s.summary = "Uses your test cases to write example documentation for your API."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = '0.0.1'
end
