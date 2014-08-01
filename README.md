# Allure RSpec Adaptor

Adaptor to use the Allure framework along with the RSpec

## What's new

* *0.5.1* - Migrating to allure-ruby-api.
* *0.4.2* - Support for labels (feature,story,severity,language,framework).
* *0.4.1* - Support for before/after(:step) hooks.
* *0.3.1* - Allure 1.4.0 format support.

## Setup

Add the dependency to your Gemfile

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

You can specify the directory where the Allure test results will appear. By default it would be 'allure/data' within
your current directory.

```ruby
    AllureRSpec.configure do |c|
      c.output_dir = "/whatever/you/like" # default: allure/data
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

  it "should be steps enabled", :story => ["First story", "Second story"] do

    step "step1" do
      attach_file "screenshot1", take_screenshot_as_file
    end

    step "step2" do
      5.should be > 0
    end

    step "step3" do
      0.should == 0
    end

    attach_file "screenshot2", take_screenshot_as_file
  end
end
```
