# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "allure-rspec/version"

Gem::Specification.new do |s|
  s.name          = 'allure-rspec'
  s.version       = AllureRSpec::Version::STRING
  s.platform         = Gem::Platform::RUBY
  s.authors       = ['Ilya Sadykov']
  s.email         = ['smecsia@yandex-team.ru']
  s.description   = %q{Adaptor to use Allure framework along with the RSpec 2}
  s.summary       = "allure-rspec-#{AllureRSpec::Version::STRING}"
  s.homepage      = 'http://allure.qatools.ru'
  s.license       = 'Apache2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'rspec', '~> 3.2'
  s.add_dependency 'allure-ruby-adaptor-api', '0.6.10'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
end
