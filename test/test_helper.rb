require "simplecov"
SimpleCov.start
require_relative '../lib/doc_yo_self'
require 'minitest/autorun'
require 'pry'

# Some stub structs that act like a 
Request  = Struct.new :method, :params, :path
Response = Struct.new :body, :success?

request  = Request.new("GET", {id: 12}, 'api/users')
response = Response.new('{"id": 12, "name": "rick"}', true)