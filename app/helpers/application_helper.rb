module ApplicationHelper
  def review_stars
    [5, 4, 3, 2, 1].map { |number| [(("&#9733;") * number).html_safe, number] }
  end
end
