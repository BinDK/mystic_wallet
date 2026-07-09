class Rack::Attack
  throttle("api/ip", limit: 100, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/api/")
  end

  throttle("api/user", limit: 20, period: 1.minute) do |req|
    if req.path.start_with?("/api/") && req.params["api_key"].present?
      req.params["api_key"]
    end
  end
end