# SmarfDoc

(Formerly 'DocYoSelf')

![Smarf](http://i.imgur.com/f5mzeRU.png)

Too many docs spoil the broth.

SmarfDoc lets you turn your controller tests into API docs _without making changes to your test suite or how you write tests_.

Pop it into your test suite and watch it amaze.

Time for this project was provided by my employer, [SmashingBoxes](http://smashingboxes.com/). What a great place to work!

## Setup

In your gemfile:
`gem 'smarf_doc', group: :test`

In  `test_helper.rb`:
```ruby
SmarfDoc.config do |c|
  c.template_file = 'test/template.md.erb'
  c.output_file   = 'api_docs.md'
end
```

See test/fake_template.md for template examples.

To run doc generation after every controller spec, put this into your `teardown` method. Or whatever method your test framework of choice will run after *every test*.

## Minitest Usage

Running it for every test case:

```ruby
class ActionController::TestCase < ActiveSupport::TestCase
  def teardown
    DocYoSelf.run!(request, response)
  end
end
```

..or if you only want to run it on certain tests, try this:

```ruby
def test_some_api
  get :index, :users
  assert response.status == 200
  DocYoSelf.run!(request, response)
end
```

Then put this at the bottom of your `test_helper.rb`:

```ruby
MiniTest::Unit.after_tests { DocYoSelf.finish! }
```

## Rspec Usage

Put this in your `spec_helper` and smoke it.

```ruby
RSpec.configure do |config|
  config.after(:each, type: :controller) do
    SmarfDoc.run!(request, response)
  end

  config.after(:suite) { SmarfDoc.finish! }
end
```


## Usage

It will log all requests and responses by default, but you can add some **optional** parameters as well.

### Skipping documentation

```ruby
def test_stuff
  SmarfDoc.skip
  # Blahhh
end
```

## Adding notes

```ruby
def test_stuff
  SmarfDoc.note "안녕하세요. This is a note."
  # Blahhh
end
```
