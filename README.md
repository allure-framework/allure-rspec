# Allure RSpec Adaptor

[![Gem Version](https://badge.fury.io/rb/allure-rspec.svg)](http://badge.fury.io/rb/allure-rspec)

Adaptor to use the Allure framework along with the RSpec. See [an example](https://github.com/allure-examples/allure-rspec-example) project to take a quick tour.

## What's new

See the [releases](https://github.com/allure-framework/allure-rspec/releases) tab.


## Setup

Add the dependency to your Gemfile. Choose the version carefully:
* 0.5.x - for RSpec2.
* 0.6.x - for RSpec3.

```ruby
 gem 'allure-rspec'
```

And then include it in your spec_helper.rb:

```ruby
    RSpec.configure do |c|
      c.include AllureRSpec::Adaptor
    end
```

## Advanced options

You can specify the directory where the Allure test results will appear. By default it would be 'gen/allure-results'
within your current directory.

```ruby
    AllureRSpec.configure do |c|
      c.output_dir = "/whatever/you/like" # default: gen/allure-results
      c.clean_dir = false # clean the output directory first? (default: true)
    end
```

## Usage examples

```ruby
describe MySpec, :feature => "Some feature", :severity => :normal do

  before(:step) do |s|
    puts "Before step #{s.current_step}"
  end

  it "should be critical", :story => "First story", :severity => :critical do
    "string".should == "string"
  end

  it "should be steps enabled", :story => ["First story", "Second story"] do |e|

    e.step "step1" do |s|
      s.attach_file "screenshot1", take_screenshot_as_file
    end

    e.step "step2" do
      5.should be > 0
    end

    e.step "step3" do
      0.should == 0
    end

    e.attach_file "screenshot2", take_screenshot_as_file
  end
end
```
