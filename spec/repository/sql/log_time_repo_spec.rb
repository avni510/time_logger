require "spec_helper"
module SQL
  describe LogTimeRepo do
    before(:each) do
      @connection = PG::Connection.open(:dbname => "time_logger_test")
      @client_repo = ClientRepo.new(@connection)
      @employee_repo = EmployeeRepo.new(@connection)
      @log_time_repo = LogTimeRepo.new(@connection)
    end

    after(:each) do
      @connection.exec("DELETE FROM LOGTIMES")
      @connection.exec(
        "ALTER SEQUENCE logtimes_id_seq RESTART WITH 1"
      )
      @connection.exec("DELETE FROM CLIENTS")
      @connection.exec(
        "ALTER SEQUENCE clients_id_seq RESTART WITH 1"
      )
      @connection.exec("DELETE FROM EMPLOYEES")
      @connection.exec(
        "ALTER SEQUENCE employees_id_seq RESTART WITH 1"
      )
      @connection.exec("INSERT INTO EMPLOYEES (username, admin) values('defaultadmin', true)")
      @connection.close if @connection
    end

    def create_log_entry(employee_id, date, hours_worked, timecode,client=nclient)
      params = 
        { 
          "employee_id": employee_id,
          "date": date,
          "hours_worked": hours_worked,
          "timecode": timecode, 
          "client": client
        }
    end

    def create_entry_in_database
      @client_repo.create('Google')
      employee_id = 1
      date = "2017-10-01"
      hours_worked = "10"
      timecode = "Billable" 
      client = 'Google'
      log_entry = create_log_entry(employee_id, date, hours_worked, timecode, client)
      @log_time_repo.create(log_entry)
    end

    describe ".create" do
      context "the user has entered their log time" do
        it "creates a new log time entry in the database" do
          employee_id = 1
          date = "2017-01-05"
          hours_worked = "5"
          timecode = "Billable" 
          client = "Google"
          log_entry = create_log_entry(employee_id, date, hours_worked, timecode, client)
          @log_time_repo.create(log_entry)
          result = @connection.exec("SELECT * FROM LOGTIMES")
          result_entry = result.values[0] 
          expect(result_entry[1]).to eq(employee_id.to_s)
          expect(result_entry[3]).to eq(hours_worked)
        end
      end

      context "the client value is nil" do
        it "saves null in the database" do
          employee_id = 1
          date = "2017-05-01"
          hours_worked = "5"
          timecode = "Non-Billable" 
          client = nil
          log_entry = create_log_entry(employee_id, date, hours_worked, timecode, client)
          @log_time_repo.create(log_entry)
          result = @connection.exec("SELECT * FROM LOGTIMES")
          result_entry = result.values[0] 
          expect(result_entry[5]).to eq(nil)
        end
      end
    end

    describe ".find_by" do
      it "takes in a log entry id and returns the object that corresponds to that id" do
        create_entry_in_database
        log_entry_hash = 
          { 
            "id": 1,
            "employee_id": 1,
            "date": Date.strptime("2017-01-05",'%Y-%m-%d'),
            "hours_worked": 10,
            "timecode": "Billable", 
            "client": "Google"
          }
        expected_entry = TimeLogger::LogTimeEntry.new(log_entry_hash)
        log_entry_id = 1
        result_entry = @log_time_repo.find_by(log_entry_id)
        expect(result_entry.id).to eq(expected_entry.id)
        expect(result_entry.hours_worked).to eq(expected_entry.hours_worked)
      end

      it "returns nil if the id does not exist" do
        create_entry_in_database
        nonexistant_log_entry_id = 5
        result_entry = @log_time_repo.find_by(nonexistant_log_entry_id)
        expect(result_entry).to eq(nil)
      end
    end

    describe ".all" do
      it "returns a list of objects of all the log time entries that exist" do
        log_entry_1_hash = create_entry_in_database
        log_entry_2_hash = create_log_entry(1, "2017-05-01", "5", "Billable", "Google")
        log_entry_2 = @log_time_repo.create(log_entry_2_hash)
        entry_1_params = {
          :id => 1,
          :employee_id => 1,
          :hours_worked => 10,
          :date => Date.strptime("2017-10-01",'%Y-%m-%d'), 
          :timecode => "Billable", 
          :client => "Google" 
        }

        entry_2_params = {
          :id => 2,
          :employee_id => 1,
          :hours_worked => 5,
          :date => Date.strptime("2017-05-01",'%Y-%m-%d'), 
          :timecode => "Billable", 
          :client => "Google" 
        }
        expected_entries = [ TimeLogger::LogTimeEntry.new(entry_1_params), TimeLogger::LogTimeEntry.new(entry_2_params)]
        result_entries = @log_time_repo.all 
        expect(result_entries[0].id).to eq(expected_entries[0].id)
        expect(result_entries[1].hours_worked).to eq(expected_entries[1].hours_worked)
        expect(result_entries[1].client).to eq(expected_entries[1].client)
      end

      it "returns nil if no log times exist" do
        expect(@log_time_repo.all).to eq(nil)
      end
    end

    describe ".find_by_employee_id" do
        context "the employee has logged times" 
          it "retrieves all the log times for a given employee" do
            @employee_repo.create("rstarr", false)
            log_entry_1_hash = create_entry_in_database
            log_entry_2_hash = create_log_entry(2, "2017-05-01", 5, "Billable", "Google")
            log_entry_3_hash = create_log_entry(2, "2017-05-11", 5, "Billable", "Google")
            log_entry_2 = @log_time_repo.create(log_entry_2_hash)
            log_entry_3 = @log_time_repo.create(log_entry_3_hash)
            entry_1_params = {
              :id => 1,
              :employee_id => 1,
              :hours_worked => 10,
              :date => Date.strptime("2017-10-01",'%Y-%m-%d'), 
              :timecode => "Billable", 
              :client => "Google" 
            }

            entry_2_params = {
              :id => 2,
              :employee_id => 2,
              :hours_worked => 5,
              :date => Date.strptime("2017-05-01",'%Y-%m-%d'), 
              :timecode => "Billable", 
              :client => "Google" 
            }
            entry_3_params = {
              :id => 3,
              :employee_id => 2,
              :hours_worked => 5,
              :date => Date.strptime("2017-05-11",'%Y-%m-%d'), 
              :timecode => "Billable", 
              :client => "Google" 
            }
            expected_entries = [ TimeLogger::LogTimeEntry.new(entry_2_params), TimeLogger::LogTimeEntry.new(entry_3_params)]
            result_entries = @log_time_repo.find_by_employee_id(2) 
            expect(result_entries[0].client).to eq(expected_entries[0].client)
            expect(result_entries[1].timecode).to eq(expected_entries[1].timecode)
          end

        context "the employee does not have logged times" do
          it "returns nil" do
            nonexistent_id = 5
            result_entries = @log_time_repo.find_by_employee_id(nonexistent_id)
            expect(result_entries).to eq(nil)
          end
        end
      end

    describe ".find_total_hours_worked_for_date" do
      it "returns the total hours for a given date" do
        @employee_repo.create("rstarr", false)
        log_entry_1 = create_entry_in_database
        log_entry_2_hash = create_log_entry(2, "2017-05-11", 7, "Billable", "Google")
        log_entry_3_hash = create_log_entry(2, "2017-05-11", 5, "Billable", "Google")
        @log_time_repo.create(log_entry_2_hash)
        @log_time_repo.create(log_entry_3_hash)
        result_hours = @log_time_repo.find_total_hours_worked_for_date(2, "05-11-2017")
        expect(result_hours).to eq(12)
      end

      context "there are no entries for a given date" do
        it "returns 0" do
          create_entry_in_database
          nonexistent_date = "12-01-2016"
          result_hours = @log_time_repo.find_total_hours_worked_for_date(1, nonexistent_date)
          expect(result_hours).to eq(0)
        end
      end
    end

    describe ".sorted_current_month_entries_by_employee_id" do
      it "returns the log entries for the current month sorted by date and filtered by employee id" do
        current_month = Date.today.month
        log_entry_1 = create_entry_in_database
        @employee_repo.create("rstarr", false)
        log_entry_2_hash = create_log_entry(2, "2017-#{current_month}-11", 7, "Billable", "Google")
        log_entry_3_hash = create_log_entry(2, "2017-#{current_month}-10", 12, "Billable", "Google")
        log_entry_4_hash = create_log_entry(2, "2016-12-10", 5, "Billable", "Google")
        @log_time_repo.create(log_entry_2_hash)
        @log_time_repo.create(log_entry_3_hash)
        entry_1_params = {
          :id => 2,
          :employee_id => 2,
          :hours_worked => 7,
          :date => Date.strptime("2017-#{current_month}-11",'%Y-%m-%d'), 
          :timecode => "Billable", 
          :client => "Google" 
        }
        entry_2_params = {
          :id => 3,
          :employee_id => 2,
          :hours_worked => 12,
          :date => Date.strptime("2017-#{current_month}-10",'%Y-%m-%d'), 
          :timecode => "Billable", 
          :client => "Google" 
        }
        expected_entries = [ TimeLogger::LogTimeEntry.new(entry_2_params), TimeLogger::LogTimeEntry.new(entry_1_params) ]
        result_entries = @log_time_repo.sorted_current_month_entries_by_employee_id(2)
        expect(result_entries.count).to eq(expected_entries.count)
        expect(result_entries[0].client).to eq(expected_entries[0].client)
        expect(result_entries[0].id).to eq(expected_entries[0].id)
      end

      it "returns nil if there are no entries for an employee" do
        create_entry_in_database
        nonexistent_id = 2
        result_entries = @log_time_repo.sorted_current_month_entries_by_employee_id(nonexistent_id)
        expect(result_entries).to eq(nil)
      end
    end

    describe ".employee_client_hours" do
      context "all entries have a client" do
        it "returns a hash of the client name and hours worked for each client for the current month" do
          current_month = Date.today.month
          log_entry_1 = create_entry_in_database
          @employee_repo.create("rstarr", false)
          @client_repo.create("Microsoft")
          log_entry_2_hash = create_log_entry(2, "2017-#{current_month}-11", 7, "Billable", "Microsoft")
          log_entry_3_hash = create_log_entry(2, "2017-#{current_month}-10", 12, "Billable", "Google")
          log_entry_4_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "Billable", "Google")
          log_entry_5_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "PTO", nil)
          @log_time_repo.create(log_entry_2_hash)
          @log_time_repo.create(log_entry_3_hash)
          @log_time_repo.create(log_entry_4_hash)
          @log_time_repo.create(log_entry_5_hash)
          expected_hash = 
            {
              Google: 17, 
              Microsoft: 7
            }
          result_hash = @log_time_repo.employee_client_hours(2)
          expect(result_hash["Google"]).to eq(expected_hash[:Google])
          expect(result_hash["Microsoft"]).to eq(expected_hash[:Microsoft])
        end
      end

      context "no entries have a client" do
        it "returns an empty hash" do
          current_month = Date.today.month
          @employee_repo.create("rstarr", false)
          log_entry_1_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "PTO", nil)
          log_entry_2_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "Non-Billable", nil)
          @log_time_repo.create(log_entry_1_hash)
          @log_time_repo.create(log_entry_2_hash)
          result_hash = @log_time_repo.employee_client_hours(2)
          expect(result_hash).to eq({})
        end
      end

      context "no log time entries exist" do
        it "returns an empty hash" do
          result_hash = @log_time_repo.employee_client_hours(2)
          expect(result_hash).to eq({})
        end
      end
    end

    describe ".employee_timecode_hours" do
      it "returns a hash of timecode and hours worked for each timecode" do
        current_month = Date.today.month
        log_entry_1 = create_entry_in_database
        @employee_repo.create("rstarr", false)
        @client_repo.create("Microsoft")
        log_entry_2_hash = create_log_entry(2, "2017-#{current_month}-11", 7, "Billable", "Microsoft")
        log_entry_3_hash = create_log_entry(2, "2017-#{current_month}-10", 12, "Billable", "Google")
        log_entry_4_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "Non-Billable", nil)
        log_entry_5_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "PTO", nil)
        log_entry_6_hash = create_log_entry(2, "2016-06-10", 5, "PTO", nil)
        @log_time_repo.create(log_entry_2_hash)
        @log_time_repo.create(log_entry_3_hash)
        @log_time_repo.create(log_entry_4_hash)
        @log_time_repo.create(log_entry_5_hash)
        expected_hash = 
          {
              "Billable": 19, 
              "Non-Billable": 5,
              "PTO": 5
          }
        result_hash = @log_time_repo.employee_timecode_hours(2)
        expect(result_hash["Billable"]).to eq(expected_hash[:Billable])
        expect(result_hash["PTO"]).to eq(expected_hash[:PTO])
      end

      context "no log time entries exist" do
        it "returns an empty hash" do
          result_hash = @log_time_repo.employee_timecode_hours(2)
          expect(result_hash).to eq({})
        end
      end
    end

    describe ".company_timecode_hours" do
      it "returns a hash of the timecode and total hours per timecode" do
        current_month = Date.today.month
        @employee_repo.create("rstarr", false)
        log_entry_1_hash = create_log_entry(2, "2017-#{current_month}-10", 12, "Billable", "Google")
        log_entry_2_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "Non-Billable", nil)
        log_entry_3_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "PTO", nil)
        log_entry_4_hash = create_log_entry(2, "2017-#{current_month}-10", 5, "PTO", nil)
        log_entry_5_hash = create_log_entry(2, "2016-06-10", 5, "PTO", nil)
        @log_time_repo.create(log_entry_1_hash)
        @log_time_repo.create(log_entry_2_hash)
        @log_time_repo.create(log_entry_3_hash)
        @log_time_repo.create(log_entry_4_hash)
        @log_time_repo.create(log_entry_5_hash)
        expected_hash = 
          {
              "Billable": 12, 
              "Non-Billable": 5,
              "PTO": 10
          }
        result_hash = @log_time_repo.company_timecode_hours
        expect(result_hash["Billable"]).to eq(expected_hash[:Billable])
        expect(result_hash["PTO"]).to eq(expected_hash[:PTO])
      end

      context "there are no entries" do
        it "returns nil" do
          result_hash = @log_time_repo.company_timecode_hours
          expect(result_hash).to eq({})
        end
      end
    end

    describe ".company_client_hours" do
      it "returns a hash of the client and total hours per client" do
        current_month = Date.today.month
        log_entry_1 = create_entry_in_database
        @employee_repo.create("rstarr", false)
        @employee_repo.create("gharrison", false)
        @client_repo.create("Microsoft")
        log_entry_2_hash = create_log_entry(2, "2017-#{current_month}-11", 7, "Billable", "Microsoft")
        log_entry_3_hash = create_log_entry(2, "2017-#{current_month}-10", 12, "Billable", "Google")
        log_entry_4_hash = create_log_entry(3, "2017-#{current_month}-10", 5, "Billable", "Google")
        log_entry_5_hash = create_log_entry(2, "2016-05-10", 5, "PTO", nil)
        @log_time_repo.create(log_entry_2_hash)
        @log_time_repo.create(log_entry_3_hash)
        @log_time_repo.create(log_entry_4_hash)
        @log_time_repo.create(log_entry_5_hash)
        expected_hash = 
          {
            Google: 17, 
            Microsoft: 7
          }
        result_hash = @log_time_repo.company_client_hours
        expect(result_hash["Google"]).to eq(expected_hash[:Google])
        expect(result_hash["Microsoft"]).to eq(expected_hash[:Microsoft])
      end

      context "there are no entries" do
        it "returns nil" do
          result_hash = @log_time_repo.company_client_hours
          expect(result_hash).to eq({})
        end
      end
    end
  end
end
