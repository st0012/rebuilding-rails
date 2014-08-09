require "./config/application.rb"
require "rack/commonlogger"
# require "rackamole"

class BenchMarker
  def initialize(app, runs = 100)
    @app, @runs = app, runs
  end

  def call(env)
    t = Time.now

    result = nil
    @runs.times { result = @app.call(env) }

    t2 = Time.now - t
    STDERR.puts <<OUTPUT
Benchmark:
  #{@runs} runs
  #{t2.to_f} seconds total
  #{t2.to_f * 1000.0 / @runs} millisec/run
OUTPUT
    
    result
  end
end

use BenchMarker, 1
# use Rack::ContentLength
use Rack::ContentType
use Rack::Runtime

run BestQuotes::Application.new

