class MoviesController < ApplicationController
  def index
    @filterrific = initialize_filterrific(
      Movie,
      params[:filterrific]
      # persistence_id: false
    ) or return
    @movies = @filterrific.find

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
  end

  def create
    response = ::TheMovieDbApi.new.find_by_id(params[:movie_id])
    if response[:success]
      @movie = Movie.new(title: response[:movie_params]['title'], overview: response[:movie_params]['overview'],
                         vote_count: response[:movie_params]['vote_count'], poster_path: response[:movie_params]['poster_path'], 
                         release_date: response[:movie_params]['release_date'])
      @movie.save!
      redirect_to movies_index_path, notice: 'movie created!'
    else
      redirect_to movies_index_path, notice: 'No movie with that id was found!'
    end
  end

  def find_by_api
  end

  def find_api_name
    @movies_response = ::TheMovieDbApi.new.find_by_name(params[:movie_name])
    render 'find_by_api'
  end

  def create_movie
    @movie_id = params[:movie_id]
    @response = ::TheMovieDbApi.new.find_by_id(@movie_id)
    if @response[:success]
      movie = Movie.new(title: @response[:movie_params]['title'], overview: @response[:movie_params]['overview'],
                        vote_count: @response[:movie_params]['vote_count'], poster_path: @response[:movie_params]['poster_path'], 
                        release_date: @response[:movie_params]['release_date'])
      movie.save!
    end
  end
end
