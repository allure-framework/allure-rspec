# Allure RSpec Adaptor

Adaptor to use the Allure framework along with the RSpec

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
      c.output_dir = "/whatever/you/like"
    end
```

## Usage examples

```ruby
describe AllureRSpec do

  it "should build" do
    step "step1" do
      attach_file "screenshot1", take_screenshot_as_file
    end

    step "step2" do
      5.should be < 1
    end

    step "step3" do
      0.should == 0
    end

    attach_file "screenshot2", take_screenshot_as_file
  end
end
```
