require "./config/application.rb"
app = BestQuotes::Application.new

use Rack::ContentType
use Rack::MethodOverride

app.route do
  resources :quotes
  # match "", "quotes#index"
  # match "sub-app", proc { [200, {}, ["Hello, sub-app!"]] }
  # match ":controller/:id/:action"
  # match ":controller/:id", :default => { "action" => "show" }
  # match ":controller", :default => { "action" => "index" }
end

run app