require "test/unit"
require "vlad/push"

class TestVladPush < Test::Unit::TestCase
  def test_sanity
    assert system("rake -T vlad:push")
    assert system("rake -T vlad:push | grep push")
  end
end
