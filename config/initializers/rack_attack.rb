class Rack::Attack
  throttle("api/ip", limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  throttle("api/user", limit: 20, period: 1.minute) do |req|
    key = req.get_header("HTTP_X_API_KEY").presence || req.params["api_key"].presence
    key if req.path.start_with?("/api/")
  end
end