require 'test_helper'

class Rake::EnvTest < Minitest::Test
  include Rake::DSL

  def setup
    Rake::Task.clear
    Rake::TaskManager.record_task_metadata = true
  end

  def teardown
    Rake::TaskManager.record_task_metadata = false
    Rake.application.thread_pool.join
  end

  def test_that_it_has_a_version_number
    refute_nil ::Rake::Env::VERSION
  end

  def test_extended_task_env
    t = task(:foo)
    assert_instance_of Rake::Env::Variables, t.env
  end

  def test_keep_variable_between_tasks
    val1 = nil
    val2 = nil

    ns1 = namespace :ns1 do
      task :env do |t|
        t.env['key'] = 'value'
      end
      task :task => :env do |t|
        val1 = t.env['key']
      end
    end

    t2 = task :task do |t|
      val2 = t.env['key']
    end

    t1 = ns1[:task]
    t1.invoke
    t2.invoke

    assert_equal 'value', val1
    assert_nil val2
  end
end
