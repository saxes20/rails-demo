class Movie < ActiveRecord::Base
  def self.all_ratings
    return Movie.select(:rating).map(&:rating).uniq
  end

  def self.with_ratings(ratings_list)
    if (ratings_list.nil?)
      return Movie.all
    end
    return Movie.where(rating: ratings_list)
  end
end
