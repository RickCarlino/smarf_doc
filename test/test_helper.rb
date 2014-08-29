require "simplecov"
SimpleCov.start
require_relative '../lib/doc_yo_self'
require 'minitest/autorun'
require 'pry'

class DysTest < Minitest::Unit::TestCase
  def setup
    DocYoSelf.config do |c|
      c.template_file = 'test/fake_template.md'
      c.output_file   = 'test/fake_output.md'
    end
  end

  def teardown
    DocYoSelf.finish!
  end

  # Include some fake structs that act like response/request objects.
  Request  = Struct.new :method, :params, :path
  Response = Struct.new :body, :success?

  def request
    Request.new("GET", {id: 12}, 'api/users')
  end

  def response
    Response.new('{"id": 12, "name": "rick"}', true)
  end
end
