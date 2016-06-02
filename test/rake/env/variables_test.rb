require 'test_helper'

class Rake::Env::TestVariables < Minitest::Test
  class TM
    include Rake::TaskManager
  end

  def setup
    @env = Rake::Env::Variables.instance
  end

  def test_default_variables
    @env.reset!
    assert_equal ENV.to_hash, @env
  end

  def test_variables_at_scope
    @env.reset!
    @env['foo'] = 'bar'
    assert_equal '', @env.scope
    assert_equal Hash['foo', 'bar'], @env.at('')
    assert_equal Hash[], @env.at('other')
  end

  def test_variables_in_scope
    @env.reset!

    @env.in!('ns1')
    @env['foo'] = 1
    assert_equal 1, @env['foo']
    assert_nil @env['bar']

    @env.in!('ns2')
    @env['bar'] = 2
    assert_nil @env['foo']
    assert_equal 2, @env['bar']

    @env.in!('ns1:ns2')
    assert_equal 1, @env['foo']
    assert_nil @env['bar']
    @env['bar'] = 3
    assert_equal 1, @env['foo']
    assert_equal 3, @env['bar']
  end

  def test_variables_on_scope
    @env.reset!

    @env.on('foo') do |env|
      env['bar'] = 1
    end

    assert_nil @env['bar']
    assert_equal Hash['bar', 1], @env.at('foo')
  end

  def test_scope_path_of
    @env.reset!

    s = Rake::Scope.make('path', 'scope')
    assert_equal 'scope:path', @env.send(:scope_path_of, s)

    tm = TM.new
    t = nil
    ns = tm.in_namespace('ns') do
      t = tm.define_task(Rake::Task, :foo)
    end
    assert_equal 'ns', @env.send(:scope_path_of, t)

    assert_equal 'ns1:ns2', @env.send(:scope_path_of, 'ns1:ns2')

    [nil, 1, Array.new, Hash.new].each do |obj|
      assert_raises(Rake::Env::InvalidScopeError) { @env.send(:scope_path_of, obj) }
    end
  end
end
