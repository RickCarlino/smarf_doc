require_relative "test_helper"
require "erb"

class TestMap < Minitest::Unit::TestCase # Minitest::Test

  let(:dys) { DocYoSelf.new }

  def test_new
    assert dys.is_a?(DocYoSelf)
  end

  def test_templating
    dys.template = "<%= 2 + 2 %>"
  end
end