require 'erb'

class DocYoSelf::TestCase
  attr_reader :request, :response, :created_at, :note
  attr_accessor :template

  def initialize(request, response, note = '')
    @request, @response, @note = request, response, note
    @created_at         = Time.now
  end

  def compile_template
    ERB.new(template).result binding
  end
end