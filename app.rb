# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do  # returns the list of albums as an HTML page
    repo = AlbumRepository.new
    @albums = repo.all
    
    return erb(:albums)
  end

  get '/albums/new' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:new_album)
  end

  get '/albums/:id' do
    repo = AlbumRepository.new
    @album = repo.find(params[:id])

    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(@album.artist_id)

    return erb(:album)
  end


  post '/albums' do
    def invalid_request_params?
      return true if params[:title] == nil || params[:release_year] == nil
      return true if params[:title] == "" || params[:release_year] == ""
      return false
    end

    if invalid_request_params?  # call method to validate request parameters
      status 400
      return ''
    end

    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    ''
  end

  get '/artists' do
    repo = ArtistRepository.new
    @all_artists = repo.all

    return erb(:artists)
  end

  get '/artists/new' do
    return erb(:new_artist)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])

    return erb(:artist)
  end

  post '/artists' do
    repo = ArtistRepository.new
    new_artist = Artist.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    ''
  end

  

end