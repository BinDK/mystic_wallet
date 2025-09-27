class SimpleRoute
  def initialize(app)
    @app = app
  end

  def call(env)
    request_path = env["PATH_INFO"]

    if request_path == "/up"
      [
        200,
        { "Content-Type" => "application/json" },
        [ { status: "ok", message: "Application is running" }.to_json ]
      ]
    else
      [
        503,
        {
          "Content-Type" => "application/json",
          "Retry-After" => "3600"
        },
        [ {
          error: "Service Unavailable",
          message: "Application is in maintenance mode",
          code: 503
        }.to_json ]
      ]
    end
  end
end
