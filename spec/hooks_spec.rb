require 'spec_helper'

describe 'When I test allure rspec' do
  before(:all) do
    puts 'Before all in foo spec'
  end

  it 'should do something' do
    puts 'In the test'
    expect(true).not_to be_nil
  end
end