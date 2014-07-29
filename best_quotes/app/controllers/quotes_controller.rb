class QuotesController < Rulers::Controller
  def a_quote
    render :a_quote, author: "Stan"
  end

  def exceptions
    raise "It's a bad one!" 
  end
end