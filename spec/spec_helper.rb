$LOAD_PATH << File.expand_path('../lib', __FILE__)

require "time_logger/web/app"
require "rspec/json_expectations"
require "time_logger" 
require "time_logger/console/console"
def session
    last_request.env['rack.session']
end
