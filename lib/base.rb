class SmarfDoc
  attr_accessor :tests
  def initialize
    @tests = []
    @skip = false
  end

  def sort_by_url!
    @tests.sort! do |x, y|
      x.request.path <=> y.request.path
    end
  end

  def clean_up!
    @tests = []
  end

  def note(msg)
    @note = msg || ''
  end

  def run!(request, response)
    if @skip
      @skip = false
      return
    end
    add_test_case(request, response, @note)
    @note = ''
    self
  end

  def add_test_case(request, response, note)
    test = self.class::TestCase.new(request, response, note)
    test.template = self.class::Conf.template
    self.tests << test
  end

  def skip
    @skip = true
  end

  def output_testcases_to_file
    docs = self.class::Conf.output_file
    raise 'No output file specific for SmarfDoc' unless docs
    File.delete docs if File.exists? docs
    write_to_file
  end

  def write_to_file
    File.open(self.class::Conf.output_file, 'a') do |file|
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
    current.run!(request, response)
  end

  def self.skip
    current.skip
  end

  def self.note(msg)
    current.note(msg)
  end

  def self.current
    Thread.current[:dys_instance] ||= self.new
  end

  def self.config(&block)
    yield(self::Conf)
  end
end
