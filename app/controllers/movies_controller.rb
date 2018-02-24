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
    @ratings=@all_ratings # default to show all the categories
    if params[:sort]!=nil
      session[:sort]=params[:sort] # new settings being remembered
    end
    if params[:ratings]!=nil
      @movies=Movie.where(rating: params[:ratings].keys).order(session[:sort])
      session[:ratings]=params[:ratings]
      @ratings=params[:ratings].keys
    elsif session[:ratings]!=nil
      @movies=Movie.where(rating: session[:ratings].keys).order(session[:sort])
      @ratings=session[:ratings].keys
    else
      @movies=Movie.all.order(session[:sort])
    end
    
    if session[:sort]=='title'
      @movie_title_hilite='hilite'
    elsif session[:sort]=='release_date'
      #@movies=Movie.order('release_date')
      @release_hilite='hilite'
    end
    if (params[:sort] == nil or params[:ratings] == nil) and session[:sort] and session[:ratings]
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
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
