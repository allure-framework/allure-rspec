require 'spec_helper'
require 'tempfile'

describe "Some feature", :feature do
  describe "Some story", :story do
    it "20 should be greater than 19", :story do
      expect(20).to be > 19
    end
  end

end
