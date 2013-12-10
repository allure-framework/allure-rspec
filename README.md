# Allure RSpec Adaptor

Adaptor to use the Allure framework along with the RSpec

## How to use

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

You can specify the directory where the allure test results will appear:

```ruby
    AllureRSpec.configure do |c|
      c.output_dir = "/whatever/you/like"
    end
```
