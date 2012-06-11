class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort_by = params[:sort_by].to_s
    ratings = params[:ratings]  #an array of ratings
    query = Movie
    if (!sort_by.empty?)
      query = Movie.order(sort_by + " asc")
    end
    if (!ratings.nil?)
      in_clause = ratings.keys.map{|e| e.to_s }
      query = query.where("rating in (?)", in_clause)
    end
    @movies = query.all
    @class_title = "title".eql?(sort_by) ? "hilite" : nil
    @class_release_date = "release_date".eql?(sort_by) ? "hilite" : nil
    @all_ratings = Movie.all_ratings
    @selected_ratings = ratings.nil? ? {} : ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
