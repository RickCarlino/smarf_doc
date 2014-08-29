require_relative "test_helper"

class TestTestCase < DysTest

  def dys
    @dys ||= DocYoSelf::TestCase.new(request, response)
  end

  def test_compile_template
    template     = "<%= 2 + 2 %>"
    dys.template = template
    assert_equal dys.template, template,
      "Could not set a template."
    assert_equal "4", dys.compile_template,
      "Could not compile template"
  end

  def test_compile_with_file
    DocYoSelf.config { |c| c.template_file = 'test/fake_template.md' }
    test = DocYoSelf::TestCase.new(request, response)
    test.template = DocYoSelf::Conf.template
    assert_includes test.compile_template, "use ERB"
  end

  def test_created_at
    assert dys.created_at.is_a?(Time)
  end
end