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

# = = = =

  def self.finish!
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