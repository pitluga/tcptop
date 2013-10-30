require File.expand_path('../test_helper', __FILE__)

class CollectdTest < Test::Unit::TestCase
  def test_outputs_two_putvals_for_active_and_queued
    s = ""
    Tcptop::Collectd.reading(10, 2, 'localhost', 'unicorn', StringIO.new(s))

    lines = s.split("\n")
    assert_equal 2, lines.size
    assert_match %r{PUTVAL localhost/unicorn/gauge-active \d+:10}, lines.first
    assert_match %r{PUTVAL localhost/unicorn/gauge-queued \d+:2}, lines.last
  end
end
