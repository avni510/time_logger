$LOAD_PATH << File.expand_path('../lib', __FILE__)
require "db/db"

namespace :db do
  task :create do
    DB::Setup.create
  end

  task :migrate do
    begin 
      con = PG::Connection.open(:dbname => "time_logger")
    rescue PG::Error 
      puts "please run rake db:create first"
    else
      con.close
    end
    DB::Setup.migrate
  end
end

namespace :db_test do
  task :create do
    DB::SetupTest.create
  end

  task :migrate do
    begin 
      con = PG::Connection.open(:dbname => "time_logger_test")
    rescue PG::Error 
      puts "please run rake db_test:create first"
    else
      con.close
    end
    DB::SetupTest.migrate
  end
end



