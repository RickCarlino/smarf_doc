require 'erb'

class DocYoSelf::TestCase
  attr_reader :request, :response, :created_at
  attr_accessor :template

  def initialize(request, response)
    @request, @response = request, response
    @created_at         = Time.now
  end

  def compile_template
    ERB.new(template).result
  end
end