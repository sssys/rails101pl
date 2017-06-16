class MoviesController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :favorite, :unfavorite]
  before_action :find_movie_and_check_permission , only: [:edit, :update, :destroy]
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    if @movie.save
    current_user.favorite!(@movie)
    redirect_to movies_path
  else
    render :new
  end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
    redirect_to movies_path, notice: "Update Success"
  else
    render :edit
  end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, alert: "Movie Deleted"
  end

  def favorite
    @movie = Movie.find(params[:id])

    if !current_user.is_member_of?(@movie)
      current_user.favorite!(@movie)
      flash[:notice] = "收藏电影成功！"
    else
      flash[:warning] = "已经收藏此过电影了！"
    end
    redirect_to movie_path(@movie)
  end

  def unfavorite
    @movie = Movie.find(params[:id])
    if current_user.is_member_of?(@movie)
      current_user.unfavorite!(@movie)
      flash[:alert] = "已取消收藏此电影！"
    else
      flash[:warning] = "你从未收藏此电影，怎么取消收藏"
    end
    redirect_to movie_path(@movie)
  end

  private

  def find_movie_and_check_permission
    @movie  = Movie.find(params[:id])
    if current_user != @movie.user
      redirect_to root_path, alert: "You have no permission."
    end
  end

  def movie_params
    params.require(:movie).permit(:title, :description)
  end
end
