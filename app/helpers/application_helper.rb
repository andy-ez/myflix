module ApplicationHelper
  def review_stars
    [5, 4, 3, 2, 1].map { |number| [(("&#9733;") * number).html_safe, number] }
  end

  def display_rating(review)
    review.rating ? "Rating: #{review.rating} / 5" : "Rating: None"
  end

end
