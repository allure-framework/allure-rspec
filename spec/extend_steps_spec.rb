require 'spec_helper'
require 'tempfile'

describe AllureRSpec, :feature => "Basics" do

  before(:suite) do
    puts "before suite"
  end

  before(:context) do
    puts "before context"
  end

  before(:step) do |s|
    puts "before step #{s.current_step}"
  end

  before(:example) do
    puts "before example"
  end

  after(:step) do |s|
    puts "after step #{s.current_step}"
  end

  after(:example) do
    puts "after example"
  end

  after(:suite) do
    puts "after suite"
  end

  after(:context) do
    puts "after all"
  end

  it "should build", :story => "Main story" do |e|
    e.attach_file "test-file1", Tempfile.new("test")
    e.step "step1" do |step|
      step.attach_file "test-file2", Tempfile.new("test")
    end

    e.step "step2" do |step|
      step.attach_file "logo", File.new("logo.png")
      expect(5).to be > 1
    end

    e.step "step3" do
      expect(0).to eq(1)
    end
  end

  it "should be failed example" do
    fail_spec "Failure"
  end

  def fail_spec(desc)
    raise RSpec::Expectations::ExpectationNotMetError.new(desc)
  end

  it "should raise exception" do |e|

    e.step "step1" do
      expect(5).to be > 1
    end

    e.step "step2" do
      raise "Undesired exception"
    end

  end

  it "is a pending example"

  context "some context" do
    it do |e|
      expect("aa").to eq("aa")
    end

    it do |e|
      expect(5).to eq(6)
    end
  end

end
