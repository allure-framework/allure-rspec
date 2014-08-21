require 'spec_helper'
require 'tempfile'

describe AllureRSpec, :feature => "Basics" do

  before(:suite) do
    puts "before suite"
  end

  before(:all) do
    puts "before all"
  end

  before(:step) do |s|
    puts "before step #{s.current_step}"
  end

  before(:each) do
    puts "before each"
  end

  after(:step) do |s|
    puts "after step #{s.current_step}"
  end

  after(:each) do
    puts "after each"
  end

  after(:suite) do
    puts "after suite"
  end

  after(:all) do
    puts "after all"
  end

  it "should build", :story => "Main story" do |ex|
    ex.attach_file "test-file1", Tempfile.new("test")
    ex.step "step1" do |step|
      step.attach_file "test-file2", Tempfile.new("test")
    end

    ex.step "step2" do |step|
      step.attach_file "logo", File.new("logo.png")
      expect(5).to be > 1
    end

    ex.step "step3" do
      expect(0).to be eql(1)
    end
  end
end
