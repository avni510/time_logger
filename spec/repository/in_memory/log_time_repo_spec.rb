require "spec_helper"
module InMemory

  describe LogTimeRepo do
    let(:mock_save_json_data) { double }
    let(:log_time_repo) { LogTimeRepo.new(mock_save_json_data) }

    def create_log_entry(employee_id, date, hours_worked, timecode,client=nil)
      params = 
        { 
          "employee_id": employee_id,
          "date": date,
          "hours_worked": hours_worked,
          "timecode": timecode, 
          "client": client
        }
      log_time_repo.create(params)
    end

    it "keeps track of the log time entries per user" do
      expect(log_time_repo.entries).to eq([])
    end

    describe ".create" do
      context "the user has entered their log time" do
        it "creates an instance of the object LogTimeEntry and add it to entries" do
          create_log_entry(1,"2016-09-07", "8","Non-Billable")

          expect(log_time_repo.entries[0].id).to eq(1) 
          expect(log_time_repo.entries[0].hours_worked).to eq(8)
        end
      end
    end

    describe ".find_by" do
      it "takes in a log entry id and returns the object that corresponds to that id" do
        create_log_entry(1, "2016-09-05", "10", "PTO")

        result = log_time_repo.find_by(1)

        expect(result.id).to eq(1)
        expect(result.date.day).to eq(5)
      end

      it "returns nil if the id does not exist" do
        result = log_time_repo.find_by(1)

        expect(result).to eq(nil)
      end
    end

    describe ".save" do
      it "passes the entries to a method that will handle storing the data in the proper format" do
        expect(mock_save_json_data).to receive(:log_time).with(log_time_repo.entries)

        log_time_repo.save
       end
    end

    describe ".all" do
      it "returns a list of objects of all the log time entries that exist" do
        create_log_entry(1,"2016-09-04", "8","Non-Billable")

        create_log_entry(1,"2016-09-02", "8","Non-Billable")

        create_log_entry(1,"2016-09-07", "8","Non-Billable")

        result = log_time_repo.all

        expect(result.count).to eq(3)
      end
    end

    describe ".find_by_employee_id" do
        context "the employee has logged times" 
          it "retrieves all the log times for a given employee" do

            create_log_entry(1,"2016-09-07", "8","Non-Billable")

            create_log_entry(1,"2016-09-08", "8","PTO")

            create_log_entry(2,"2016-09-07", "8","Non-Billable")

            result_array = log_time_repo.find_by_employee_id(1)

            result_array.each do |result|
              expect(result.employee_id).to eq(1)
            end
          end

        context "the employee does not have logged times" do
          it "returns nil" do
            result = log_time_repo.find_by_employee_id(5)

            expect(result).to eq(nil)
          end
        end
      end

    describe ".find_total_hours_worked_for_date" do
      it "returns the total hours for a given date" do
        create_log_entry(1,"2016-09-07", "8","Non-Billable")

        create_log_entry(1,"2016-09-07", "8","Non-Billable")

        create_log_entry(1,"2016-09-08", "7","Non-Billable")

        result = log_time_repo.find_total_hours_worked_for_date(1, "09-07-2016")
        expect(result).to eq(16)
      end

      context "there are no entries for a given date" do
        it "returns 0" do
          create_log_entry(1,"2016-09-08", "7","Non-Billable")

          result = log_time_repo.find_total_hours_worked_for_date(1, "09-07-2016")

          expect(result).to eq(0)
        end
      end
    end

    describe ".sorted_current_month_entries_by_employee_id" do
      it "returns the log entries for the current month sorted by date and filtered by employee id" do
        create_log_entry(1,"2016-09-04", "8","Non-Billable")

        create_log_entry(1,"2016-09-02", "8","Non-Billable")

        create_log_entry(1,"2016-08-07", "8","Non-Billable")

        create_log_entry(1,"2015-12-07", "8","Non-Billable")

        create_log_entry(2,"2016-9-07", "8","Non-Billable")

        allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
        result = log_time_repo.sorted_current_month_entries_by_employee_id(1)

        expect(result[0].date.day).to eq(2)
        expect(result.count).to eq(2)
      end

      it "returns nil if there are no entries for an employee" do
        create_log_entry(2,"2016-9-07", "8","Non-Billable")

        result = log_time_repo.sorted_current_month_entries_by_employee_id(1)

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

          result = log_time_repo.employee_client_hours(1)

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

        create_log_entry(1,"2016-09-07", "8","Billable", "Google")

        create_log_entry(1,"2016-09-07", "6","Billable", "Microsoft")

        create_log_entry(1,"2016-09-07", "6", "PTO")

        allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))

        result = log_time_repo.employee_client_hours(1)

        client_hash = 
          {
            "Google" => 16,
            "Microsoft" => 6
          }

        expect(result).to eq(client_hash)
        end
      end

      context "no entries have a client" do
        it "returns an empty hash" do

          create_log_entry(1,"2016-09-05", "8","PTO")

          create_log_entry(1,"2016-09-07", "6", "PTO")

          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))

          result = log_time_repo.employee_client_hours(1)

          client_hash = {}

          expect(result).to eq(client_hash)
        end
      end

      context "no log time entries exist" do
        it "returns an empty hash" do
          result = log_time_repo.employee_client_hours(1)

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

        result = log_time_repo.employee_timecode_hours(1)

        timecode_hash = 
          {
            "Billable" => 8,
            "PTO" => 14
          }

        expect(result).to eq(timecode_hash)
      end

      context "no log time entries exist" do
        it "returns an empty hash" do
          result = log_time_repo.employee_timecode_hours(1)

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

          create_log_entry(3,"2016-09-07", "6", "PTO")

          result = log_time_repo.company_timecode_hours

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

          create_log_entry(3,"2016-09-07", "6", "PTO")

          result = log_time_repo.company_timecode_hours

          timecode_hash = 
            {
              "Billable" => 6,
              "PTO" => 6
            }

          expect(result).to eq(timecode_hash)
        end
      end

      context "there are no entries" do
        it "returns nil" do
          result = log_time_repo.company_timecode_hours
          expect(result).to eq(nil)
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

          create_log_entry(3,"2016-09-07", "6", "PTO")

          result = log_time_repo.company_client_hours

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

          create_log_entry(3,"2016-09-07", "6", "PTO")

          result = log_time_repo.company_client_hours

          client_hash = 
            {
              "Microsoft" => 6
            }

          expect(result).to eq(client_hash)
        end
      end

      context "there are no entries" do
        it "returns nil" do
          result = log_time_repo.company_client_hours

          expect(result).to eq(nil)
        end
      end
    end
  end
end
