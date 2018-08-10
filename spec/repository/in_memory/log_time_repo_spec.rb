require "spec_helper"
module InMemory
  describe LogTimeRepo do
    before(:each) do
      @file_wrapper = double
      @json_store = JsonStore.new(@file_wrapper)
      data = 
        {
          "employees": 
          [
            {
              "id": 1,
              "username": "defaultadmin",
              "admin": true,
              "log_time": [
                {
                  "id": 1,
                  "date": "2017-01-01",
                  "hours_worked": 1,
                  "timecode": "Non-Billable",
                  "client": nil
                }
              ]
            },
            {
              "id": 2,
              "username": "rstarr",
              "admin": false,
              "log_time": [
                {
                  "id": 2,
                  "date": "2017-01-02",
                  "hours_worked": 1,
                  "timecode": "Non-Billable",
                  "client": nil
                },
                {
                  "id": 3,
                  "date": "2017-01-02",
                  "hours_worked": 1,
                  "timecode": "Non-Billable",
                  "client": nil
                }
              ]
            }
          ],
          "clients": [
            {
              "id": 1,
              "name": "Google"
            }
          ]
        }
      data = JSON.parse(JSON.generate(data))
      expect(@file_wrapper).to receive(:read_data).and_return(data)
      @json_store.load
      @employee_repo = EmployeeRepo.new(@json_store)
      @log_time_repo = LogTimeRepo.new(@json_store) 
    end

    def create_log_entry(employee_id, date, hours_worked, timecode,client=nil)
      params = 
        { 
          "employee_id": employee_id,
          "date": date,
          "hours_worked": hours_worked,
          "timecode": timecode, 
          "client": client
        }
      @log_time_repo.create(params)
    end

    def generate_entry_hash(id, employee_id, date, hours_worked, timecode, client)
        { 
          "id": id,
          "employee_id": employee_id,
          "date": Date.strptime(date, '%Y-%m-%d'),
          "hours_worked": hours_worked.to_i, 
          "timecode": timecode, 
          "client": client
        }
    end

    describe ".log_time_entries" do
      it "returns an array of log time objects from the data array" do
        entry_hash_1 = generate_entry_hash(1, 1, "2017-01-01", 1, "Non-Billable", nil)
        entry_hash_2 = generate_entry_hash(2, 2, "2017-01-02", 1, "Non-Billable", nil)
        expected_array = 
          [ 
            TimeLogger::LogTimeEntry.new(entry_hash_1),
            TimeLogger::LogTimeEntry.new(entry_hash_2)
          ]
        result_array = @log_time_repo.log_time_entries
        expect(result_array[0].id).to eq(expected_array[0].id)
        expect(result_array[1].hours_worked).to eq(expected_array[1].hours_worked)
      end
    end


    describe ".create" do
      context "the user has entered their log time" do
        it "creates an instance of the object LogTimeEntry and add it to entries" do
          create_log_entry(1,"2016-09-07", "8","Non-Billable")
          result = @log_time_repo.log_time_entries
          expect(result.count).to eq(4)
          expect(result[1].id).to eq(4)
          expect(result[1].hours_worked).to eq(8)
        end
      end
    end

    describe ".find_by" do
      it "takes in a log entry id and returns the object that corresponds to that id" do
        result = @log_time_repo.find_by(1)
        expect(result.id).to eq(1)
        expect(result.date.day).to eq(1)
      end

      it "returns nil if the id does not exist" do
        result = @log_time_repo.find_by(6)
        expect(result).to eq(nil)
      end
    end

    describe ".all" do
      it "returns a list of objects of all the log time entries that exist" do
        result = @log_time_repo.all
        expect(result.count).to eq(3)
      end
    end

    describe ".find_by_employee_id" do
        context "the employee has logged times" 
          it "retrieves all the log times for a given employee" do
            result_array = @log_time_repo.find_by_employee_id(2)
            result_array.count(2)
            result_array.each do |result|
              expect(result.employee_id).to eq(2)
            end
          end

        context "the employee does not have logged times" do
          it "returns nil" do
            result = @log_time_repo.find_by_employee_id(6)
            expect(result).to eq(nil)
          end
        end
      end

    describe ".find_total_hours_worked_for_date" do
      it "returns the total hours for a given date" do
        create_log_entry(1,"2016-09-07", "8","Non-Billable")
        create_log_entry(1,"2016-09-07", "8","Non-Billable")
        create_log_entry(1,"2016-09-08", "7","Non-Billable")
        result = @log_time_repo.find_total_hours_worked_for_date(1, "09-07-2016")
        expect(result).to eq(16)
      end

      context "there are no entries for a given date" do
        it "returns 0" do
          create_log_entry(1,"2016-09-08", "7","Non-Billable")
          result = @log_time_repo.find_total_hours_worked_for_date(1, "09-07-2016")
          expect(result).to eq(0)
        end
      end
    end

    describe ".sorted_current_month_entries_by_employee_id" do
      it "returns the log entries for the current month sorted by date and filtered by employee id" do
        create_log_entry(1,"2016-09-04", "8","Non-Billable")
        create_log_entry(1,"2016-09-02", "8","Non-Billable")
        allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
        result = @log_time_repo.sorted_current_month_entries_by_employee_id(1)
        expect(result[0].date.day).to eq(2)
        expect(result.count).to eq(2)
      end

      it "returns nil if there are no entries for an employee" do
        result = @log_time_repo.sorted_current_month_entries_by_employee_id(3)
        expect(result).to eq(nil)
      end
    end

    describe ".employee_client_hours" do
      context "all entries have a client" do
        it "returns a hash of the client name and hours worked for each client" do
          create_log_entry(1,"2016-09-05", "8","Billable", "Google")
          create_log_entry(1,"2016-09-07", "8","Billable", "Google")
          create_log_entry(1,"2016-09-07", "6","Billable", "Microsoft")
          create_log_entry(2,"2016-09-07", "6","Billable", "Microsoft")
          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
          result = @log_time_repo.employee_client_hours(1)
          client_hash = 
            {
              "Google" => 16,
              "Microsoft" => 6
            }

          expect(result).to eq(client_hash)
        end
      end

      context "not all entries have a client" do
        it "filters out the entries without a client and returns a hash hours worked for each client" do
        create_log_entry(1,"2016-09-05", "8","Billable", "Google")
        allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
        result = @log_time_repo.employee_client_hours(1)
        client_hash = 
          {
            "Google" => 8
          }
        expect(result).to eq(client_hash)
        end
      end

      context "no entries have a client" do
        it "returns an empty hash" do
          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
          result = @log_time_repo.employee_client_hours(1)
          client_hash = {}
          expect(result).to eq(client_hash)
        end
      end

      context "no log time entries exist" do
        it "returns an empty hash" do
          @employee_repo.create("gharrison", false)
          result = @log_time_repo.employee_client_hours(3)
          client_hash = {}
          expect(result).to eq(client_hash)
        end
      end
    end

    describe ".employee_timecode_hours" do
      it "returns a hash of timecode and hours worked for each timecode" do
        create_log_entry(1,"2016-09-05", "8","Billable", "Google")
        create_log_entry(1,"2016-09-07", "8","PTO")
        create_log_entry(1,"2016-09-07", "6", "PTO")
        allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
        result = @log_time_repo.employee_timecode_hours(1)
        timecode_hash = 
          {
            "Billable" => 8,
            "PTO" => 14
          }
        expect(result).to eq(timecode_hash)
      end

      context "no log time entries exist" do
        it "returns an empty hash" do
          @employee_repo.create("gharrison", false)
          result = @log_time_repo.employee_timecode_hours(3)
          timecode_hash = {}
          expect(result).to eq(timecode_hash)
        end
      end
    end

    describe ".company_timecode_hours" do
      context "all entries are for the current month of September" do
        it "returns a hash of the timecode and total hours per timecode" do
          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
          create_log_entry(1,"2016-09-05", "8","Billable", "Google")
          create_log_entry(2,"2016-09-07", "8","Non-Billable")
          create_log_entry(2,"2016-09-07", "6","Billable", "Microsoft")
          create_log_entry(2,"2016-09-07", "6", "PTO")
          result = @log_time_repo.company_timecode_hours
          timecode_hash = 
            {
              "Billable" => 14,
              "Non-Billable" => 8,
              "PTO" => 6
            }
          expect(result).to eq(timecode_hash)
        end
      end

      context "entries have date entries other than current month or year" do
        it "returns a hash of timecodes for the current month and year" do
          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
          create_log_entry(1,"2016-08-05", "8","Billable", "Google")
          create_log_entry(2,"2015-09-07", "8","Non-Billable")
          create_log_entry(2,"2016-09-07", "6","Billable", "Microsoft")
          create_log_entry(2,"2016-09-07", "6", "PTO")
          result = @log_time_repo.company_timecode_hours
          timecode_hash = 
            {
              "Billable" => 6,
              "PTO" => 6
            }
          expect(result).to eq(timecode_hash)
        end
      end
    end

    describe ".company_client_hours" do
      context "all entries are for the current month of September" do
        it "returns a hash of the client and total hours per client" do
          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
          create_log_entry(1,"2016-09-05", "8","Billable", "Google")
          create_log_entry(2,"2016-09-07", "8","Non-Billable")
          create_log_entry(2,"2016-09-07", "6","Billable", "Microsoft")
          create_log_entry(2,"2016-09-07", "6", "PTO")
          result = @log_time_repo.company_client_hours
          client_hash = 
            {
              "Google" => 8,
              "Microsoft" => 6,
            }
          expect(result).to eq(client_hash)
        end
      end

      context "entries have date entries other than current month or year" do
        it "returns a hash of clients for the current month and year" do
          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
          create_log_entry(1,"2016-08-05", "8","Billable", "Google")
          create_log_entry(2,"2015-09-07", "8","Non-Billable")
          create_log_entry(2,"2016-09-07", "6","Billable", "Microsoft")
          create_log_entry(2,"2016-09-07", "6", "PTO")
          result = @log_time_repo.company_client_hours
          client_hash = 
            {
              "Microsoft" => 6
            }
          expect(result).to eq(client_hash)
        end
      end
    end
  end
end
