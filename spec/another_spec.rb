require 'spec_helper'
require 'tempfile'

describe "Some another spec", :feature => ["Some Feature"], :severity => :normal do

  before(:suite) do
    puts "before suite"
  end

  after(:suite) do
    puts "after suite"
  end

  it "10 cannot be greater than 19", :story => ["Some story"], :testId => 10  do
    expect(10).to be > 19
  end

  it "4 must not be equal to 5", :testId => 20 do
    expect(5).to be eql(4)
  end
end
