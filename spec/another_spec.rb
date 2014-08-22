require 'spec_helper'
require 'tempfile'

describe "Some another spec", :feature => ["Some Feature"], :severity => :normal do

  before(:each) do
    puts "before each"
  end

  after(:each) do
    puts "after each"
  end

  it "10 cannot be greater than 19", :story => ["Some story"]  do
    expect(10).to be > 19
  end

  it "4 must not be equal to 5" do
    expect(5).to be eql(4)
  end
end
