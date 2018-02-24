class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=['G','PG','PG-13','R']
    if @ratings.nil?
      @ratings={}
      @all_ratings.each {|i| @ratings[i]=1}
    end
    if params[:ratings]
      @movies=Movie.where(rating: params[:ratings].keys)
    end
    if params[:sort]=='title'
      @movies = Movie.order('title ASC')
      @movie_title_hilite='hilite'
    elsif params[:sort]=='release'
      @movies = Movie.order('release_date ASC') 
      @release_hilite='hilite'
    else 
      params[:ratings] ? @movies=Movie.where(rating: params[:ratings].keys): 
                         @movies=Movie.all
    end
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

end
