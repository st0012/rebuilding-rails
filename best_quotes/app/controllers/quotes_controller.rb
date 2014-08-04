class QuotesController < Rulers::Controller

  def index
    @quotes = FileModel.all
    render_response :index
  end

  def show
    @quote = FileModel.find(params["id"])
    render_response :show
  end

  def new
    render_response :new
  end

  def create
    params = decode(env['rack.input'].gets)
    @quote = FileModel.create(params)
    render_response :show
  end

  def edit
    @quote = FileModel.find(params["id"])
    render_response :edit
  end

  def update
    params = decode(env['rack.input'].gets)
    @quote = FileModel.find(params["id"])
    @quote.update(params)
    @quote.save
    render_response :show
  end

  def destroy
    params = decode(env['rack.input'].gets)
    @quote = FileModel.find(params["id"])
    @quote.destroy
    @quotes = FileModel.all
    render_response :index
  end
end