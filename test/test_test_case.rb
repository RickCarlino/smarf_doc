require_relative "test_helper"

class TestTestCase < SmarfDocTest

  def test_case
    @test_case ||= SmarfDoc::TestCase.new(request, response)
  end

  def test_compile_template
    template = "<%= 2 + 2 %>"
    test_case.template = template
    assert_equal test_case.template, template,
      "Could not set a template."
    assert_equal "4", test_case.compile_template,
      "Could not compile template"
  end

  def test_compile_with_file
    SmarfDoc.config { |c| c.template_file = 'test/fake_template.md' }
    test = SmarfDoc::TestCase.new(request, response)
    test.template = SmarfDoc::Conf.template
    assert_includes test.compile_template, "use ERB"
  end

  def test_created_at
    assert test_case.created_at.is_a?(Time)
  end
end
