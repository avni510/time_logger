require 'pg'
module DB
  require "spec_helper"

  describe Setup do

    def create_and_migrate
      Setup.create
      Setup.migrate
    end

    def connect_to_db
      begin 
        con = PG::Connection.open(:dbname => "time_logger")
      rescue => e
        return false
      else
        con.close
      end
    end

    def teardown 
      connection = PG::Connection.open(:dbname => "postgres")
      connection.exec("DROP DATABASE time_logger")
      connection.close
    end

    describe ".create" do

      context "rake db:create has been run" do
        it "creates the db" do
          if connect_to_db == false
            Setup.create
            expect { @con = PG::Connection.open(:dbname => "time_logger") }.to_not raise_error
            @con.close
          else
            teardown
            Setup.create
            expect { @con = PG::Connection.open(:dbname => "time_logger") }.to_not raise_error
            @con.close
          end
          teardown
        end
      end
    end

      
    describe ".migrate" do
      context "rake db:create is run" do
        before(:all) do
          if connect_to_db == false
            create_and_migrate
          else
            teardown
            create_and_migrate
          end          
          @con = PG::Connection.open(:dbname => "time_logger")
        end

        after(:all) do
          @con.close
        end

        it "created the employees table" do
          expect { @con.exec("SELECT * FROM employees") }.to_not raise_error
        end

        it "created the clients table" do
          expect { @con.exec("SELECT * FROM clients") }.to_not raise_error
        end

        it "created the logtimes table" do
          expect { @con.exec("SELECT * FROM logtimes") }.to_not raise_error
        end

        it "created the timecodes table" do
          expect { @con.exec("SELECT * FROM timecodes") }.to_not raise_error
        end

        it "added a defaultadmin user to the employees table" do
          result = @con.exec("SELECT * FROM employees WHERE Username='defaultadmin'")
          expect(result.count).to eq(1)
          result.each do |row|
            expect(row["username"]).to eq("defaultadmin")
          end
        end
      end
    end
  end
end
