class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = @all_ratings
    @ratings = params[:ratings]

    should_redirect = 0

    if !(params[:sort].nil?)
      @sort = params[:sort]
      session[:sort] = params[:sort]
    elsif !(session[:sort].nil?)
      @sort = session[:sort]
      should_redirect = 1
    else
      @sort = nil
    end

    if !(params[:ratings].nil?)
      @ratings = params[:ratings]
      @ratings_to_show = @ratings.keys
      session[:ratings] = params[:ratings]
    elsif !(session[:ratings].nil?)
      @ratings = session[:ratings]
      should_redirect = 1
    else
      @ratings = nil
    end

    if should_redirect == 1
      flash.keep
      redirect_to movies_path :sort => @sort, :ratings => @ratings
    end

    @movies = Movie.with_ratings(@ratings_to_show, @sort)

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
