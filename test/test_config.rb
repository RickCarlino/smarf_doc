require_relative "test_helper"

class TestConfig < SmarfDocTest

  def test_set_configs
    SmarfDoc.config do |c|
      c.template_file = 'test/template.md.erb'
      c.output_file   = 'api_docs.md'
    end
    assert_equal 'api_docs.md', SmarfDoc::Conf.output_file,
      "Unable to set output file"
    assert_equal 'test/template.md.erb', SmarfDoc::Conf.template_file,
      "Unable to set template file"
  end
end
