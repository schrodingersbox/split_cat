$:.push File.expand_path('../lib', __FILE__)

require 'split_cat/version'

Gem::Specification.new do |s|

  s.name        = 'split_cat'
  s.version     = SplitCat::VERSION
  s.licenses    = ['MIT']
  s.authors     = ['Rich Humphrey']
  s.email       = ['rich@schrodingersbox.com']
  s.homepage    = 'https://github.com/schrodingersbox/split_cat'
  s.summary     = 'A Rails engine for split testing'
  s.description =<<-EOD
    This framework allows you to assign anonymous users to experiments with goals and weighted hypotheses.
    It makes experiments easy to configure and implement.
    The reporting side still needs some work.
  EOD

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.0', '>= 4.0.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec', '~> 2.14', '>= 2.14.0'
  s.add_development_dependency 'rspec-rails', '~> 2.14', '>= 2.14.0'
  s.add_development_dependency 'webrat', '~> 0.7', '>= 0.7.3'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'

end
