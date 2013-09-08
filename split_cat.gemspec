$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'split_cat/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'split_cat'
  s.version     = SplitCat::VERSION
  s.authors     = ['Rich Humphrey']
  s.email       = ['rich@schrodingersbox.com']
  s.homepage    = "https://github.com/schrodingersbox/split_cat"
  s.summary     = 'A Rails engine for split testing'
  s.description = ''

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.0.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec', '~>2.14.0'
  s.add_development_dependency 'rspec-rails', '~>2.14.0'
  s.add_development_dependency 'webrat', '~>0.7.3'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
end
