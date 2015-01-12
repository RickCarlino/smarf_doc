# Doc Yo Self

An auto documentation for Rails. Pop it into your test suite and watch it amaze.

Time for this project was provided by my employer, [SmashingBoxes](http://smashingboxes.com/). What a great place to work.

# Limitations

 * **Probably not thread safe**. Thread safety isn't a focus for this project right now. Pull requests welcome :-).


## Setup

In your gemfile:
`gem 'doc_yo_self', group: :test`

In  `test_helper.rb`:
```ruby
DocYoSelf.config do |c|
  c.template_file = 'test/template.md.erb'
  c.output_folder   = 'wiki'
end
```

See test/fake_template.md for template examples.

To run doc generation after every controller spec, put this into your `teardown` method. Or whatever method your test framework of choice will run after *every test*.

## For Minitest Folks


At the bottom of your `test_helper.rb`:

```ruby
MiniTest::Unit.after_tests { DocYoSelf.finish! }
```

Then

```ruby
def test_some_api
  get :index, :users
  assert response.status == 200
  DocYoSelf.new.run!(self, response: response)
end
```
or

```ruby
  def setup
    @doc_yo_self = DocYoSelf.new
  end

  def teardown
    @doc_yo_self.run!(self)
  end
```



## Options

It will log all requests and responses by default, but you can add some **optional** parameters as well.
Options can be passed as a hash to the `run!` function or directly to the instance methods:

## Adding notes
Defaults to the test name
```ruby
@doc_yo_self.note =  "This is fun"
```

## Output file
Defaults to the test class name
```ruby
@doc_yo_self.output_file = "fun.md"
```

## Response
Defaults to self.response
```ruby
@doc_yo_self.response = @json
```

##request
Defaults to self.request
```ruby
@doc_yo_self.request = other_request
```
