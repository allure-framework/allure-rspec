require 'rspec'
require 'allure-rspec'
require 'nokogiri'

RSpec.configure do |c|
  c.include AllureRSpec::Adaptor
end

AllureRSpec.configure do |c|
  c.output_dir = "allure"
end