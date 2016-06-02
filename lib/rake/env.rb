require "rake/env/version"
require 'rake/env/variables'

unless defined? ActiveSupport
  require 'hash/deep_merge'
end

module Rake
  class Task
    def env
      Rake::Env::Variables.instance.in!(self)
    end
  end
end
