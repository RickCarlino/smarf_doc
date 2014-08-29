require_relative "test_helper"

class TestConfig < DysTest

  def test_set_configs
    DocYoSelf.config do |c|
      c.template_file = 'test/template.md.erb'
      c.output_file   = 'api_docs.md'
    end
    assert_equal 'api_docs.md', DocYoSelf::Conf.output_file,
      "Unable to set output file"
    assert_equal 'test/template.md.erb', DocYoSelf::Conf.template_file,
      "Unable to set template file"
  end
end
