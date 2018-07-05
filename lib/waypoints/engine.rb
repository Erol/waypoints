require "waypoints/middleware"

module Waypoints
  class Engine < ::Rails::Engine
    initializer "waypoints.middleware" do |app|
      app.config.app_middleware.use Waypoints::Middleware
    end
  end
end
