module TimeLogger
  require "spec_helper"

  describe LogTimeRepo do
    let(:mock_save_json_data) { double }
    let(:log_time_repo) { LogTimeRepo.new(mock_save_json_data) }

    it "keeps track of the log time entries per user" do
      expect(log_time_repo.entries).to eq([])
    end

    describe ".create" do
      context "the user has entered their log time" do
        it "creates an instance of the object LogTimeEntry and saves that to entries" do
          employee_id = 1
          date = "09-07-2016"
          hours_worked = "8"
          timecode = "Non-Billable"
          client = nil


          log_time_repo.create(employee_id, date, hours_worked, timecode)

          expect(log_time_repo.entries[0]).to be_a_kind_of(LogTimeEntry)
        end
      end

      context "an entry is already been entered" do
        it "adds the user's log time to entries" do
          employee_id = 1
          date = "09-07-2016"
          hours_worked = "8"
          timecode = "Non-Billable"
          client = nil

          log_time_repo.create(employee_id, date, hours_worked, timecode)

          employee_id = 1
          date = "09-08-2016"
          hours_worked = "8"
          timecode = "PTO"
          client = nil

          log_time_repo.create(employee_id, date, hours_worked, timecode)

          log_time_repo.entries.each do |entry|
            expect(entry).to be_a_kind_of(LogTimeEntry)
          end
        end
      end
    end

    describe ".find_by" do
      it "retrieves all the log times for a given employee" do

        employee_id = 1
        date = "09-07-2016"
        hours_worked = "8"
        timecode = "Non-Billable"
        client = nil

        log_time_repo.create(employee_id, date, hours_worked, timecode)

        employee_id = 1
        date = "09-08-2016"
        hours_worked = "8"
        timecode = "PTO"
        client = nil

        log_time_repo.create(employee_id, date, hours_worked, timecode)

        employee_id = 2
        date = "09-07-2016"
        hours_worked = "8"
        timecode = "Non-Billable"
        client = nil

        log_time_repo.create(employee_id, date, hours_worked, timecode)

        result_array = log_time_repo.find_by(1)

        result_array.each do |result|
          expect(result.employee_id).to eq(1)
        end
      end

      context "an employee has logged times for the date entered" do
        it "retrieves the hours worked for a given employee and given date" do
          employee_id = 1
          date = "09-07-2016"
          hours_worked = "8"
          timecode = "Non-Billable"
          client = nil

          log_time_repo.create(employee_id, date, hours_worked, timecode)

          employee_id = 1
          date = "09-07-2016"
          hours_worked = "8"
          timecode = "Non-Billable"
          client = nil

          log_time_repo.create(employee_id, date, hours_worked, timecode)

          employee_id = 1
          date = "09-07-2016"
          hours_worked = "7"
          timecode = "Non-Billable"
          client = nil

          log_time_repo.create(employee_id, date, hours_worked, timecode)

          employee_id = 1
          date = "09-08-2016"
          hours_worked = "7"
          timecode = "Non-Billable"
          client = nil

          log_time_repo.create(employee_id, date, hours_worked, timecode)

          result_array = log_time_repo.find_by(1, "09-07-2016")

          result_array.each do |result|
            expect(result.date).to eq("09-07-2016")
          end
        end
      end

      context "the employee has no logged times for the date entered" do
        it "retrieves the hours worked for a given employee and given date" do

          result_array = log_time_repo.find_by(1, "09-07-2016")

          expect(result_array).to eq([])
        end
      end
    end

    describe ".save" do
      it "passes the entries to a method that will handle storing the data in the proper format" do
        expect(mock_save_json_data).to receive(:log_time).with(log_time_repo.entries)

        log_time_repo.save
      end
    end
  end
end
