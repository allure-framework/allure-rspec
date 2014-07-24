require 'spec_helper'
require 'tempfile'

describe AllureRSpec do

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

  it "should build" do
    attach_file "test-file1", Tempfile.new("test")
    step "step1" do
      attach_file "test-file2", Tempfile.new("test")
    end

    step "step2" do
      attach_file "logo", File.new("logo.png")
      5.should be > 1
    end

    step "step3" do

      0.should == 1
    end
  end
end
