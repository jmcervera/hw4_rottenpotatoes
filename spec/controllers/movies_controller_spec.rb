require 'spec_helper'
describe MoviesController do
  it "should recognize find_similar_movie route" do
    {:get => "/movies/12/find_similar"}.should route_to(
      controller: 'movies', action: 'find_similar', id: '12'
    )
  end

  describe "find similar movies search" do

    before(:each) do
      @results = [double("movie"), double("movie")]
      @movie = double("movie")
      @movie.stub(:find_similar).and_return(@results)
      @movie.stub(:director).and_return("director_name")
      Movie.stub(:find).and_return(@movie)
    end

    it "should find the specified movie" do
      Movie.should_receive(:find).with("1")
      get :find_similar, {:id => 1}
    end

    it "should call the model method that performs the search" do
      @movie.should_receive(:find_similar)
      get :find_similar, {:id => 1}
    end

    it "should make results available to template" do
      get :find_similar, {:id => 1}
      assigns(:similar_movies).should == @results
    end

    it "should select the find_similar template for rendering" do
      get :find_similar, {:id => 1}
      response.should render_template('find_similar')
    end

  end

  describe 'when there are no similar movies' do
    before do
      @results = []
      @movie = double("movie")
      @movie.stub(:find_similar).and_return(@results)
      @movie.stub(:director).and_return(nil)
      @movie.stub(:title).and_return("Alien")
      Movie.stub(:find).and_return(@movie)
    end

    it "must redirect to '/'" do
      get :find_similar, {:id => 1}
      response.should redirect_to(root_path)
      flash[:warning].should eql("'Alien' has no director info")
    end
  end
end
