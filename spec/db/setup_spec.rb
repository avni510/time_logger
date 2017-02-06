require "spec_helper"
module DB
  describe Setup do
    around do |example|
      begin
        connection = PG::Connection.open(:dbname => "postgres")
        connection.exec("SET client_min_messages TO WARNING")
        connection.exec("DROP DATABASE IF EXISTS time_logger")
        connection.exec("DROP DATABASE IF EXISTS time_logger_test")
        connection.exec("RESET client_min_messages")
        example.run
      ensure
        connection.close if connection
      end
    end

    describe ".create" do
      it "creates the production db" do
        begin
          Setup.create(:production)
          expect { @con = PG::Connection.open(:dbname => "time_logger") }.to_not raise_error
        ensure
          @con.close if @con
        end
      end

      it "creates the test db" do
        begin
          Setup.create(:test)
          expect { @con = PG::Connection.open(:dbname => "time_logger_test") }.to_not raise_error
        ensure
          @con.close if @con
        end
      end
    end

    describe ".migrate" do
      context "it runs a migration for the production db" do
        before do
          Setup.create(:production)
          Setup.migrate(:production)
          @con = PG::Connection.open(:dbname => "time_logger")
        end

        after do
          @con.close if @con
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

        it "added timecodes to the timecodes table" do
          result = @con.exec("SELECT * FROM TIMECODES")
          expect(result.count).to eq(3)
          first_row = result.values[0]
          expect(first_row[1]).to eq("Non-Billable")
        end
      end

      context "it runs a migration for the test db" do
        before do
          Setup.create(:test)
          Setup.migrate(:test)
          @con = PG::Connection.open(:dbname => "time_logger_test")
        end

        after do
          @con.close if @con
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

        it "added timecodes to the timecodes table" do
          result = @con.exec("SELECT * FROM TIMECODES")
          expect(result.count).to eq(3)
          first_row = result.values[0]
          expect(first_row[1]).to eq("Non-Billable")
        end
      end
    end
  end
end
