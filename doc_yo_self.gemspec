$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.authors = ['Rick Carlino']
  s.description = "An automatic API documentation generator."
  s.email = 'rick.carlino@gmail.com'
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/rickcarlino/doc_yo_self'
  s.license = 'MIT'
  s.name = 'doc_yo_self'
  s.require_paths = ['lib']
  s.summary = "Uses your test cases to write example documentation for your API."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = '0.0.2'
end