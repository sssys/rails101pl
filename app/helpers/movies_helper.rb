module MoviesHelper
  def render_movie_description(movie)
    simple_format(movie.description)
  end

  def render_review_content(review)
    simple_format(review.content)
  end
end
