class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :find_movie_and_check_permission, only: [:new, :create]

  def new
    @review = Review.new
  end

  def edit
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
  end

  def create
    @review = Review.new(review_params)
    @review.movie = @movie
    @review.user = current_user

    if @review.save
      redirect_to movie_path(@movie)
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to account_reviews_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to account_reviews_path, alert: "Review Delete"
  end


  private
  def review_params
    params.require(:review).permit(:content)
  end

  def find_movie_and_check_permission
    @movie = Movie.find(params[:movie_id])
    if !current_user.is_member_of?(@movie)
      redirect_to movie_path(@movie), alert: "You need to favorite the movie before you write a review."
    end
  end

end
