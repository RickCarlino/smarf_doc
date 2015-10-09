require_relative "test_helper"

class TestBase < SmarfDocTest

  def test_run!
    tests = SmarfDoc.current.tests
    assert_equal 0, tests.length,
      "Expected current tests to be an empty array"
    SmarfDoc.run!(request, response)
    assert_equal 1, tests.length,
      "Expected run!() to increase number of tests"
    assert tests.first.is_a?(SmarfDoc::TestCase)
    SmarfDoc.run!(request, response)
    assert_equal 2, tests.length,
      "Expected run!() to increase number of tests"
    assert_includes tests.first.compile_template,
        "You can use ERB to format each test case",
        "Did not load correct template file"
  end

  def test_sort!
    first = Request.new("GET", {id: 12}, 'api/aaa')
    last  = Request.new("GET", {id: 12}, 'api/zzz')
    SmarfDoc.run!(first, response)
    SmarfDoc.run!(last, response)
    results = SmarfDoc.current.sort_by_url!.map{|tc| tc.request.path}
    assert_equal ["api/aaa", "api/zzz"], results,
      "Did not sort test cases by request URL"
  end

  def test_finish!
    file = SmarfDoc::Conf.output_file
    first = Request.new("GET", {id: 12}, 'api/aaa')
    last  = Request.new("GET", {id: 12}, 'api/zzz')
    SmarfDoc.run!(first, response)
    SmarfDoc.run!(last, response)
    SmarfDoc.finish!
    assert File.exists?(file),
      "Did not create an output file after finish!()ing"
    assert_includes File.read(file), "You can use ERB",
      "Did not utilize template to output docs."
  end

  def test_skip
    file = SmarfDoc::Conf.output_file
    tests= SmarfDoc.current.tests
    first = Request.new("GET", {id: 12}, 'api/skip')
    last  = Request.new("GET", {id: 12}, 'api/noskip')
    SmarfDoc.skip
    SmarfDoc.run!(first, response)
    SmarfDoc.run!(last, response)
    assert_equal 1, tests.length,
      "DYS Did not skip tests."
    assert_equal 'api/noskip', tests.first.request.path,
      "DYS Did not skip tests."
  end
  
  def test_multiple_skips
    file = SmarfDoc::Conf.output_file
    tests= SmarfDoc.current.tests
    first = Request.new("GET", {id: 12}, 'api/noskip1')
    second = Request.new("GET", {id: 12}, 'api/skip1')
    third  = Request.new("GET", {id: 12}, 'api/skip2')
    fourth  = Request.new("GET", {id: 12}, 'api/noskip2')
    SmarfDoc.run!(first, response)
    SmarfDoc.skip
    SmarfDoc.run!(second, response)
    SmarfDoc.skip
    SmarfDoc.run!(third, response)
    SmarfDoc.run!(fourth, response)
    assert_equal 2, tests.length,
      "DYS Skipped 2 tests."
    assert_equal 'api/noskip1', tests[0].request.path,
      "DYS Did not skip first unskipped test."
    assert_equal 'api/noskip2', tests[1].request.path,
      "DYS Did not skip second unskipped test."
  end

  def test_note
    file = SmarfDoc::Conf.output_file
    tests= SmarfDoc.current.tests
    first = Request.new("GET", {id: 12}, 'api/skip')
    last  = Request.new("GET", {id: 12}, 'api/noskip')
    SmarfDoc.note "안녕하세요"
    SmarfDoc.run!(first, response)
    SmarfDoc.run!(last, response)
    assert_includes tests.first.compile_template, "안녕하세요",
      "Could not find note in documentation."
  end
end
