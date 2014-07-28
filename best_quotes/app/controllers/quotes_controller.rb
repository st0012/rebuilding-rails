class QuotesController < Rulers::Controller

  def a_quote
    "Hello! Welcome to " + "\n<pre>\n#{env}</pre>" + "\n<pre>\n#{env["PATH_INFO"]}</pre>"
  end

  def exceptions
    raise "It's a bad one!" 
  end
end