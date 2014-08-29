require "simplecov"
SimpleCov.start
require_relative '../lib/doc_yo_self'
require 'minitest/autorun'
require 'pry'

class DysTest < Minitest::Unit::TestCase
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
