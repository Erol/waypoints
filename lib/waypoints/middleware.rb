require "waypoints/tracer"

module Waypoints
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      filepath = File.join(Rails.root, "log", "waypoint-#{Time.now.to_i}-#{env["REQUEST_URI"].parameterize}.png")

      Waypoints::Tracer.trace filepath do
        @app.call(env)
      end
    end
  end
end
