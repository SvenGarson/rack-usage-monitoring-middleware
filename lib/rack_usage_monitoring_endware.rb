require_relative 'rack_usage_monitoring_middleware'

class Endware
  def call(env)
    
    usage_data = RackUsageMonitoring.usage_data(env)

    [
      200,
      {'Content-Type' => 'text/plain'},
      [
        "Requests total: #{usage_data.requests.total}",
        "Requests today: #{usage_data.requests.today}"        
      ].map { |str| str + "\n"}
    ]
  end
end