module ApplicationHelper
  def review_stars
    [5, 4, 3, 2, 1].map { |number| [(("&#9733;") * number).html_safe, number] }
  end

  def display_rating(review)
    review.rating ? "Rating: #{review.rating} / 5" : "Rating: None"
  end

  def rating_options(name)
    options_for_select((10..50).map { |num| num/10.0 }, params[name])
  end

  def select_tag_for_ratings(name)
    select_tag name, rating_options(name), prompt: "-", class: "form-control"
  end

end
