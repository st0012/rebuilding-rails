class QuotesController < Rulers::Controller
  puts $LOAD_PATH
  def index
    @quotes = Quote.all
    render_response :index
  end

  def show
    @quote = Quote.find(params["id"])
    render_response :show
  end

  def new
    render_response :new
  end

  def create
    params = decode(env['rack.input'].gets)
    @quote = Quote.create(params)
    redirect_to :show, @quote
  end

  def edit
    @quote = Quote.find(params["id"])
    render_response :edit
  end

  def update
    params = decode(env['rack.input'].gets)
    @quote = Quote.find(params["id"])
    @quote.update(params)
    @quote.save
    redirect_to :show, @quote
  end

  def destroy
    params = decode(env['rack.input'].gets)
    @quote = Quote.find(params["id"])
    @quote.destroy
    redirect_to :index
  end
end