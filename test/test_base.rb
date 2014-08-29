require_relative "test_helper"

class TestBase < DysTest

  def test_run!
    tests = DocYoSelf.current.tests
    assert_equal 0, tests.length,
      "Expected current tests to be an empty array"
    DocYoSelf.run!(request, response)
    assert_equal 1, tests.length,
      "Expected run!() to increase number of tests"
    assert tests.first.is_a?(DocYoSelf::TestCase)
    DocYoSelf.run!(request, response)
    assert_equal 2, tests.length,
      "Expected run!() to increase number of tests"
    assert_includes tests.first.compile_template,
        "You can use ERB to format each test case",
        "Did not load correct template file"
  end

  def test_sort!
    first = Request.new("GET", {id: 12}, 'api/aaa')
    last  = Request.new("GET", {id: 12}, 'api/zzz')
    DocYoSelf.run!(first, response)
    DocYoSelf.run!(last, response)
    results = DocYoSelf.current.sort_by_url!.map{|tc| tc.request.path}
    assert_equal ["api/aaa", "api/zzz"], results,
      "Did not sort test cases by request URL"
  end

  def test_finish!
    first = Request.new("GET", {id: 12}, 'api/aaa')
    last  = Request.new("GET", {id: 12}, 'api/zzz')
    DocYoSelf.run!(first, response)
    DocYoSelf.run!(last, response)
    binding.pry
  end
end
