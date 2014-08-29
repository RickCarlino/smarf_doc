class DocYoSelf
  def initialize
    @tests = []
  end

  def self.run!
  end

  def self.current
    Thread.current[:dys_instance] ||= self.new
  end

  def self.config(&block)
    yield(self::Conf)
  end
end