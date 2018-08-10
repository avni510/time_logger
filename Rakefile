$LOAD_PATH << File.expand_path('../lib', __FILE__)
require "db/db"

namespace :db do
  task :create do
    DB::Setup.create(:production)
  end

  task :migrate do
    begin 
      con = PG::Connection.open(:dbname => "time_logger")
    rescue PG::Error 
      puts "please run rake db:create first"
    else
      con.close
    end
    DB::Setup.migrate(:production)
  end
end

namespace :db_test do
  task :create do
    DB::Setup.create(:test)
  end

  task :migrate do
    begin 
      con = PG::Connection.open(:dbname => "time_logger_test")
    rescue PG::Error 
      puts "please run rake db_test:create first"
    else
      con.close
    end
    DB::Setup.migrate(:test)
  end
end



