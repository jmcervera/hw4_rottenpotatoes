require 'spec_helper'

describe Movie do
  it "responds to method find_similar" do
    movie = Movie.new
    movie.should respond_to(:find_similar)
  end

  context "With loaded data" do
    before do
      FactoryGirl.create(:movie, title: 'Star Wars', director: 'George Lucas')
      FactoryGirl.create(:movie, title: 'Blade Runner', director: 'Ridley Scott')
      FactoryGirl.create(:movie, title: 'Alien', director: 'Ridley Scott')
      FactoryGirl.create(:movie, title: 'THX-1138', director: 'George Lucas')
    end

    describe "find_similar" do
      it "find similar movies" do
        movie = FactoryGirl.create(:movie, title: 'The duelist', director: 'Ridley Scott')
        similar_movies = movie.find_similar
        similar_movies.should have(3).records
        similar_movies.map{|m| m.director}.uniq.should == ['Ridley Scott']
      end

      it "returns nothing if the director is not specified" do
        movie = FactoryGirl.create(:movie, title: 'The God Father', director: nil)
        similar_movies = movie.find_similar
        similar_movies.should == []
      end
    end
  end

end
