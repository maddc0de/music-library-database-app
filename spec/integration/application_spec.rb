require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_artists_table
    seed_sql = File.read('spec/seeds/artists_seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_artists_table
  end

  context 'GET /albums/new' do
    it "returns the form to add a new album" do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="album_title">')
      expect(response.body).to include('<input type="text" name="album_release_year">')
      expect(response.body).to include('<input type="text" name="album_artist_id">')
    end
  end

  context "POST albums" do
    it "validates album parameters" do
      response = post('/albums', title: "")

      expect(response.status).to eq(400) # invalid/incorrect params
    end

    it "returns 200 OK for /albums" do
      response = post('/albums', title: 'Voyage', release_year: 2022, artist_id: 2)

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')
      expect(response.body).to include('Voyage')
    end

  end

  context "POST artists" do
    it "returns 200 OK for /artists" do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      expect(response.body).to include('Wild nothing')
    end

  end

  context "GET /artists/:id" do
    it "returns info about artist 1" do
      response = get('/artists/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<p>Artist: Pixies, Genre: Rock</p>')
    end

  end

  context "GET /artists" do
    it "returns the list of artists as an HTML page with links to each artist" do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include('Name: <a href="/artists/1">Pixies</a>')  # make sure there is no extra white space on artists.erb for this line      
      expect(response.body).to include('Name: <a href="/artists/4">Nina Simone</a>') 
    end

  end

  context "GET /albums/:id" do
    it "returns info about album 1" do
      response = get('/albums/1')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end

    it "returns info about album 2" do
      response = get('/albums/2')

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
      expect(response.body).to include('Artist: Pixies')
    end

  end

  context "GET /albums" do
    it "returns the list of album as an HTML page with links to each album" do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('Title: <a href="/albums/1">Doolittle</a>')  # make sure there is no extra white space on albums.erb for this line      
      expect(response.body).to include('Title: <a href="/albums/5">Bossanova</a>')  # make sure there is no extra white space on albums.erb for this line
    end

  end

end
