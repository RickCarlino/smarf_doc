# Doc Yo Self

An auto documentation for Rails. Pop it into your test suite and watch it amaze.

# Limitations

 * **Current focus is MiniTest**. Probably will work with Rspec too, but that's not our focus right now.
 * **Probably not thread safe**. Thread safety isn't a focus for this project right now. Pull requests welcome :-).


## Setup

```ruby
DocYoSelf.config do |c|
  c.template_file = 'test/template.md.erb'
  c.output        = 'api_docs.md'
end
```

To run doc generation after every controller spec, put this into your `teardown` method. Or whatever method your test framework of choice will run after *every test*.

```ruby
def teardown
  DocYoSelf.run!
end 
```

Then put this at the bottom of your `test_helper.rb`:

```ruby
DocYoSelf.finish!
```

Or put it individually into only certain tests...

```ruby
def test_some_api
  get :index, :users
  assert response.status == 200
  DocYoSelf.run!
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
  doc_notes "This API endpoint does things."
  # Blahhh
end
```
