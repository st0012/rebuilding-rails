class QuotesController < Rulers::Controller
  def index
    @quotes = Quote.all
    render_response :index
  end

  def show
    puts params
    @quote = Quote.find(params["id"])
    render_response :show
  end

  def new
    puts "new"
    render_response :new
  end

  def create
    params = decode(request.body.read)
    @quote = Quote.create(params)
    redirect_to :show, @quote.id
  end

  def edit
    @quote = Quote.find(params["id"])
    render_response :edit
  end

  def update
    params = decode(request.body.read)
    @quote = Quote.find(params["id"])
    @quote.update(params)
    @quote.save
    redirect_to :show, @quote.id
  end

  def destroy
    params = decode(request.body.read)
    @quote = Quote.find(params["id"])
    @quote.destroy
    redirect_to :index
  end
end
