module TimeLogger
  require "spec_helper"

  describe LogTimeRepo do
    let(:mock_save_json_data) { double }
    let(:log_time_repo) { LogTimeRepo.new(mock_save_json_data) }

    def create_log_entry(employee_id, date, hours_worked, timecode, client=nil)
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
        it "creates an instance of the object LogTimeEntry and saves that to entries" do
          create_log_entry(1,"09-07-2016", "8","Non-Billable")

          expect(log_time_repo.entries[0].client).to eq(nil)
          expect(log_time_repo.entries[0]).to be_a_kind_of(LogTimeEntry)
        end
      end

      context "an entry is already been entered" do
        it "adds the user's log time to entries" do
          create_log_entry(1,"09-07-2016", "8","Non-Billable")

          create_log_entry(1,"09-08-2016", "8","PTO")

          log_time_repo.entries.each do |entry|
            expect(entry).to be_a_kind_of(LogTimeEntry)
          end
        end
      end
    end

    describe ".find_by" do
      context ".find_by is used to filter only by employee_id" do
        context "the employee has logged times" 
          it "retrieves all the log times for a given employee" do

            create_log_entry(1,"09-07-2016", "8","Non-Billable")

            create_log_entry(1,"09-08-2016", "8","PTO")

            create_log_entry(2,"09-07-2016", "8","Non-Billable")

            result_array = log_time_repo.find_by(1)

            result_array.each do |result|
              expect(result.employee_id).to eq(1)
            end
          end

        context "the employee does not have logged times" do
          it "returns nil" do
            result = log_time_repo.find_by(5)

            expect(result).to eq(nil)
          end
        end
      end

      context ".find_by is used to filter for employee id and date entered" do
        context "an employee has logged times for the date entered" do
          it "retrieves the hours worked for a given employee and given date" do
            create_log_entry(1,"09-07-2016", "8","Non-Billable")

            create_log_entry(1,"09-07-2016", "8","Non-Billable")

            create_log_entry(1,"09-07-2016", "8","Non-Billable")

            create_log_entry(1,"09-08-2016", "7","Non-Billable")

            result_array = log_time_repo.find_by(1, "09-07-2016")

            result_array.each do |result|
              expect(result.date).to eq("09-07-2016")
            end
          end
        end

        context "the employee has no logged times for the date entered" do
          it "retrieves the hours worked for a given employee and given date" do

            result_array = log_time_repo.find_by(1, "09-07-2016")

            expect(result_array).to eq(nil)
          end
        end
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
        create_log_entry(1,"09-04-2016", "8","Non-Billable")

        create_log_entry(1,"09-02-2016", "8","Non-Billable")

        create_log_entry(1,"09-07-2016", "8","Non-Billable")

        result = log_time_repo.all

        expect(result.count).to eq(3)
        expect(result[-1].date).to eq("09-07-2016")
      end
    end
  end
end
