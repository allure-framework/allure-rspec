require 'spec_helper'
require 'tempfile'

describe "Some another spec" do

  before(:each) do
    puts "before each"
  end

  after(:each) do
    puts "after each"
  end

  it "10 cannot be greater than 19" do
    10.should > 19
  end

  it "4 must not be equal to 5" do
    5.should == 4
  end
end
