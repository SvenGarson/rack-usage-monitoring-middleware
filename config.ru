require_relative 'lib/rack_usage_monitoring_middleware'
require_relative 'lib/rack_usage_monitoring_endware'

use RackUsageMonitoring::Middleware
run Endware.new