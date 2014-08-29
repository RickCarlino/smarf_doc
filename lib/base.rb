class DocYoSelf
  attr_accessor :tests
  def initialize
    @tests = []
  end

  def sort_by_url!
    @tests.sort! do |x, y|
      x.request.path <=> y.request.path
    end
  end

  def clean_up!
    @tests = []
  end

  def output_testcases_to_file
    docs = self.class::Conf.output_file
    raise 'No output file specific for DocYoSelf' unless docs
    File.delete docs if File.exists? docs
    write_to_file
  end

  def write_to_file
    File.open('documentation.md', 'a') do |file|
      @tests.each do |test|
        file.write(test.compile_template)
      end
    end
  end

# = = = =

  def self.finish!
    current.sort_by_url!
    current.output_testcases_to_file
    current.clean_up!
  end

  def self.run!(request, response)
    test = self::TestCase.new(request, response)
    test.template = self::Conf.template
    current.tests << test
    self
  end

  def self.current
    Thread.current[:dys_instance] ||= self.new
  end

  def self.config(&block)
    yield(self::Conf)
  end
end