# Doc Yo Self

An auto documentation for Rails. Pop it into your test suite and watch it amaze.

Time for this project was provided by my employer, [SmashingBoxes](http://smashingboxes.com/). What a great place to work.

# Limitations

 * **Current focus is MiniTest**. Probably will work with Rspec too, but that's not our focus right now.
 * **Probably not thread safe**. Thread safety isn't a focus for this project right now. Pull requests welcome :-).


## Setup

In your gemfile:
`gem 'doc_yo_self', group: :test`

In  `test_helper.rb`:
```ruby
DocYoSelf.config do |c|
  c.template_file = 'test/template.md.erb'
  c.output_file   = 'api_docs.md'
end
```

See test/fake_template.md for template examples.

To run doc generation after every controller spec, put this into your `teardown` method. Or whatever method your test framework of choice will run after *every test*.

```ruby
class ActionController::TestCase < ActiveSupport::TestCase
  def teardown
    DocYoSelf.run!(request, response)
  end
end
```

Then put this at the bottom of your `test_helper.rb`:

```ruby
MiniTest::Unit.after_tests { DocYoSelf.finish! }
```

Or put it individually into only certain tests...

```ruby
def test_some_api
  get :index, :users
  assert response.status == 200
  DocYoSelf.run!(request, response)
end
```

## Usage

It will log all requests and responses by default, but you can add some **optional** parameters as well.

### Skipping documentation

```ruby
def test_stuff
  DocYoSelf.skip
  # Blahhh
end
```

## Adding notes

```ruby
def test_stuff
  DocYoSelf.note "안녕하세요. This is a note."
  # Blahhh
end
```
