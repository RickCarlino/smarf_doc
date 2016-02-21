# SmarfDoc

![Smarf](http://i.imgur.com/f5mzeRU.png)

Too many docs spoil the broth.

SmarfDoc lets you turn your controller tests into API docs _without making changes to your test suite or how you write tests_.

Pop it into your test suite and watch it amaze.

## Gem Installation in Rails

In your gemfile add the following to your test group:

`gem 'smarf_doc'`

Installation differs for RSpec/Minitest, so scroll to the appropriate section for guidance.

## Rspec Installation

Add this to your `rails_helper.rb` It should go outside of other blocks
(Do not place it inside the `RSpec.configure` block).
```ruby
SmarfDoc.config do |c|
  c.template_file = 'spec/template.md.erb'
  c.output_file   = 'api_docs.md'
end
```

Add the following line to `spec_helper.rb` inside the `RSpec.configure` block

`config.after(:suite) { SmarfDoc.finish! }`

It should look like this
```ruby
RSpec.configure do |config|
  # Existing code
  config.after(:suite) { SmarfDoc.finish! }
end
```
#### To run on all controller tests

Add this to your `spec_helper.rb`
```ruby
config.after(:each, type: :controller) do
  SmarfDoc.run!(request, response)
end
```

The whole file should look like this
```ruby
RSpec.configure do |config|
  # Existing code
  config.after(:each, type: :controller) do
    SmarfDoc.run!(request, response)
  end
  config.after(:suite) { SmarfDoc.finish! }
end
```
#### To run on only select tests
Just add `SmarfDoc.run!(request, response)` to specific tests
```ruby
it "responds with 200" do
  get :index
  expect(response).to be_success
  SmarfDoc.run!(request, response)
end
```

## Minitest Installation

Add the code from below to `test_helper.rb`:
```ruby
class ActiveSupport::TestCase
  # Already existing code
  SmarfDoc.config do |c|
    c.template_file = 'test/template.md.erb'
    c.output_file   = 'api_docs.md'
  end
  # More code
end

MiniTest::Unit.after_tests { SmarfDoc.finish! }
```
#### To run on all controller tests
Add this to `test_helper.rb` as well:
```ruby
class ActionController::TestCase < ActiveSupport::TestCase
  def teardown
    SmarfDoc.run!(request, response)
  end
end
```

Your code should look like this:
```ruby
class ActiveSupport::TestCase
  # Already existing code
  SmarfDoc.config do |c|
    c.template_file = 'test/template.md.erb'
    c.output_file   = 'api_docs.md'
  end
  # More code
end

class ActionController::TestCase < ActiveSupport::TestCase
  def teardown
    SmarfDoc.run!(request, response)
  end
end

MiniTest::Unit.after_tests { SmarfDoc.finish! }
```


#### To run on only select tests
Just add `SmarfDoc.run!(request, response)` to specific tests
```ruby
def get_index
  get :index
  assert response.status == 200
  SmarfDoc.run!(request, response)
end
```

## Setting a template

If you copied the code from above, SmarfDoc will look for a template file located at either
`test/template.md.erb` or `spec/template.md.erb`, depending on your test suite.
This template may be customized to fit your needs.

```erb
<%= request.method %>
<%= request.path %>
<%= request.params %>
<%= response.body %>
<%= information[:message] %>
<%= note %>
```

## Where to find the docs

By default, the docs are output to `api_docs.md` in the root of the Rails project.
You can change this by altering the config in `test_helper.rb` or `rails_helper.rb`.

## Additional Features

#### Skipping documentation on tests

To leave certain tests out of the documentation, just add `SmarfDoc.skip` to the test.

```ruby
it "responds with 200" do
  SmarfDoc.skip
  # test code
end
```

#### Adding information and notes
SmarfDoc will log all requests and responses by default, but you can add some
**optional** parameters as well.

```ruby
it "responds with 200" do
  SmarfDoc.note("This endpoint prefers butterscotch")
  # test code
end
```
#### OR
```ruby
it "responds with 200" do
  SmarfDoc.information(:message, "This endpoint only responds on Tuesdays")
  # test code
end
```

You can store any information with `:message` or any other key you can think of.
To access information in the template, just use `<%= information[:message] %>`
