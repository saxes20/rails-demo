class Movie < ActiveRecord::Base
  def self.all_ratings
    return Movie.select(:rating).map(&:rating).uniq
  end

  def self.with_ratings(ratings_list, sort_key)
    if (ratings_list.nil?) and (sort_key.nil?)
      return Movie.all
    elsif (ratings_list.nil?) and !(sort_key.nil?)
      return Movie.order(sort_key)
    elsif !(ratings_list.nil?) and (sort_key.nil?)
      return Movie.where(rating: ratings_list)
    else
      return Movie.order(sort_key).where(rating: ratings_list)
    end
    
  end
end
