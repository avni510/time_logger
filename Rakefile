require 'pg'

namespace :db do
  task :create do
    con = PG.connect :dbname => "postgres"
    con.exec("CREATE DATABASE time_logger")
  end
end



