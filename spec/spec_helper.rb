$LOAD_PATH << File.expand_path('../lib', __FILE__)

require "time_logger/web/app"
require "rspec/json_expectations"
require "time_logger" 
require "time_logger/console/console"
require "db/db"
require "time_logger/repository/sql/sql"
require "time_logger/repository/in_memory/in_memory"
def session
  last_request.env['rack.session']
end
