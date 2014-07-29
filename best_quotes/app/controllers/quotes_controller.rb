class QuotesController < Rulers::Controller
  def a_quote
    render :a_quote, author: "Stan"
  end

  def quote_1
    @quote_1 = Rulers::Model::FileModel.find(1)
    render :a_quote, obj: @quote_1, sentence: @quote_1.print_sentence 
  end

  def exceptions
    raise "It's a bad one!" 
  end
end