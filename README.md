# Rake::Env

[![Build Status](https://travis-ci.org/ak10m/rake-env.svg?branch=master)](https://travis-ci.org/ak10m/rake-env)
[![Code Climate](https://codeclimate.com/github/ak10m/rake-env/badges/gpa.svg)](https://codeclimate.com/github/ak10m/rake-env)

wle will be able to share the variables between Rake task.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rake-env'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rake-env

## Usage

```ruby
namespace :ns1 do
  task :env1 do |t|
    t.env['var1'] = 'foo'
  end

  task :task1 => :env1 do |t|
    puts t.env['var1'] # => 'foo'
    puts t.env['var2'] # => nil
  end

  task :task2 do |t|
    puts t.env['var1'] # => nil
    puts t.env['var2'] # => nil
  end

  namespace :ns2 do
    task :env2 do |t|
      t.env['var1'] = 'bar'
      t.env['var2'] = 'baz'
    end

    task :env3 => :env1 do |t|
      t.env['var2'] = 'foobar'
    end

    task :task3 => :env2 do |t|
      puts t.env['var1'] # => 'bar'
      puts t.env['var2'] # => 'baz'
    end

    task :task4 => :env1 do |t|
      puts t.env['var1'] # => 'foo'
      puts t.env['var2'] # => nil
    end

    task :task5 do |t|
      puts t.env['var1'] # => nil
      puts t.env['var2'] # => nil
    end

    task :task6 => :env3 do |t|
      puts t.env['var1'] # => 'foo'
      puts t.env['var2'] # => 'foobar'
    end
  end
end
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ak10m/rake-env.

