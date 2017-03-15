module ApplicationHelper
  def review_stars
    [5, 4, 3, 2, 1].map { |number| [(("&#9733;") * number).html_safe, number] }
  end

  def display_rating(review)
    review.rating ? "Rating: #{review.rating} / 5" : "Rating: None"
  end

  def highlighted_text(video, field, display_field=nil)
    if video.try(:highlight).try(field) 
      video.highlight[field][0].html_safe 
    else
      !display_field ? video.try(field) : video.try(display_field)
    end
  end

  def rating_options(name)
    options_for_select((10..50).map { |num| num/10.0 }, params[name])
  end

  def select_tag_for_ratings(name)
    select_tag name, rating_options(name), prompt: "-", class: "form-control"
  end

end
