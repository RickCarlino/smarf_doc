# SmarfDoc

(Formerly 'DocYoSelf')

![Smarf](http://i.imgur.com/f5mzeRU.png)

Too many docs spoil the broth.

SmarfDoc lets you turn your controller tests into API docs _without making changes to your test suite or how you write tests_.

Pop it into your test suite and watch it amaze.

Time for this project was provided by my employer, [SmashingBoxes](http://smashingboxes.com/). What a great place to work!


## Gem Installation in Rails

In your gemfile add the following to your test group:

`gem 'smarf_doc', group: :test, github: 'RickCarlino/smarf_doc'`

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

`config.after(:suite) { SmashingDocs.finish! }`

It should look like this
```ruby
RSpec.configure do |config|
  # Existing code
  config.after(:suite) { SmashingDocs.finish! }
end
```
#### To run on all controller tests

Add this to your `spec_helper.rb`
```ruby
config.after(:each, type: :controller) do
  SmashingDocs.run!(request, response)
end
```

The whole file should look like this
```ruby
RSpec.configure do |config|
  # Existing code
  config.after(:each, type: :controller) do
    SmashingDocs.run!(request, response)
  end
  config.after(:suite) { SmashingDocs.finish! }
end
```
#### To run on only select tests
Just add `SmashingDocs.run!(request, response)` to specific tests
```ruby
it "responds with 200" do
  get :index
  expect(response).to be_success
  SmashingDocs.run!(request, response)
end
```

## Minitest Installation

Add the code from below to `test_helper.rb`:
```ruby
class ActiveSupport::TestCase
  # Already existing code
  SmashingDocs.config do |c|
    c.template_file = 'test/template.md.erb'
    c.output_file   = 'api_docs.md'
  end
  # More code
end

MiniTest::Unit.after_tests { SmashingDocs.finish! }
```
#### To run on all controller tests
Add this to `test_helper.rb` as well:
```ruby
class ActionController::TestCase < ActiveSupport::TestCase
  def teardown
    SmashingDocs.run!(request, response)
  end
end
```

Your code should look like this:
```ruby
class ActiveSupport::TestCase
  # Already existing code
  SmashingDocs.config do |c|
    c.template_file = 'test/template.md.erb'
    c.output_file   = 'api_docs.md'
  end
  # More code
end

class ActionController::TestCase < ActiveSupport::TestCase
  def teardown
    SmashingDocs.run!(request, response)
  end
end

MiniTest::Unit.after_tests { SmashingDocs.finish! }
```


#### To run on only select tests
Just add `SmashingDocs.run!(request, response)` to specific tests
```ruby
def get_index
  get :index
  assert response.status == 200
  SmashingDocs.run!(request, response)
end
```

## Setting a template

If you copied the code from above, SmashingDocs will look for a template file located at either
`test/template.md.erb` or `spec/template.md.erb`, depending on your test suite.
This template may be customized to fit your needs.

```erb
<%= request.method %>
<%= request.path %>
<%= request.params %>
<%= response.body %>
<%= information[:note] %>
<%= aside %>
```

## Where to find the docs

By default, the docs are output to `api_docs.md` in the root of the Rails project.
You can change this by altering the config in `test_helper.rb` or `rails_helper.rb`.

## Additional Features

#### Skipping documentation on tests

To leave certain tests out of the documentation, just add `SmashingDocs.skip` to the test.

```ruby
it "responds with 200" do
  SmashingDocs.skip
  # test code
end
```

#### Adding information, e.g. notes
SmashingDocs will log all requests and responses by default, but you can add some
**optional** parameters as well.

```ruby
it "responds with 200" do
  SmashingDocs.information(:note, "This endpoint only responds on Tuesdays")
  # test code
end
```
You can store any information with `:note`, `:message`, or any other key you can think of.
To access information in the template, just use `<%= information[:key] %>`
