require 'erb'

class SmarfDoc::TestCase
  attr_reader :request, :response, :created_at, :note, :information
  attr_accessor :template

  def initialize(request, response, note = '', information = {})
    @request, @response, @note, @information = request, response, note, information
    @created_at         = Time.now
  end

  def compile_template
    ERB.new(template).result binding
  end
end
