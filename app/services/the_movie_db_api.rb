class TheMovieDbApi

  def initialize
    @response = {}
    @response[:success] = false
  end

  def find_by_id(movie_id)
    movie = HTTParty.get("https://api.themoviedb.org/3/movie/#{movie_id}?api_key=a9502b6da4230cff8773e764dd412cdd")
    movie_data = movie.parsed_response
    res = validate_response(movie_data)
    if res
      @response[:movie_params] = movie_data
      @response[:success] = true
    end
    @response
  rescue Exception => e
    @response
  end

  def validate_response(movie_data)
    if movie_data['status_code'] == 34
      false
    else
      true
    end
  end

  def find_by_name(movie_name)
    parsed_name = movie_name.gsub(' ', '+')
    movie = HTTParty.get("https://api.themoviedb.org/3/search/movie?api_key=a9502b6da4230cff8773e764dd412cdd&query=#{parsed_name}")
    movies_data = movie.parsed_response
    movies_data['results']
  rescue Exception => e
    @response
  end
end
