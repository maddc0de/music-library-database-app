# POST /albums Route Design Recipe

_test-drive a Sinatra route._

## 1. Design the Route Signature
  * the HTTP method : POST
  * the path: /albums
  * body parameters:
    title=Voyage
    release_year=2022
    artist_id=2

## 2. Design the Response

```md

```

## 3. Write Examples

_Replace these with your own design._

```md
# Request:

POST /albums

# Expected response:
# Response for 200 OK
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /albums" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end
  end

end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.