module TimeLogger
  require "spec_helper"

  describe ReportRetrieval do

    before(:each) do
      @employee_id = 1
      @report_retrieval = ReportRetrieval.new(@employee_id)
      @mock_log_time_repo = double
      allow(Repository).to receive(:for).and_return(@mock_log_time_repo)
    end

    def set_up_log_time_entries
      params_entry_1 = 
        { 
          "id": 1, 
          "employee_id": 1, 
          "date": Date.strptime("09-03-2016",'%m-%d-%Y'), 
          "hours_worked": 6, 
          "timecode": "Non-Billable", 
          "client": nil 
        }
      params_entry_2 = 
        { 
          "id": 2, 
          "employee_id": 1, 
          "date": Date.strptime("09-04-2016",'%m-%d-%Y'), 
          "hours_worked": 8, 
          "timecode": "PTO", 
          "client": nil 
        }

      params_entry_3 = 
        { 
          "id": 3, 
          "employee_id": 1, 
          "date": Date.strptime("09-06-2016",'%m-%d-%Y'), 
          "hours_worked": 7, 
          "timecode": "Billable", 
          "client": "Google"
        }

      log_times = 
        [
          LogTimeEntry.new(params_entry_1),
          LogTimeEntry.new(params_entry_2),
          LogTimeEntry.new(params_entry_3),
        ]
    end

    describe ".log_times" do
      context "employee_id 1 exists with log times and the current month is September" do
        it "returns a list of log time objects for the current month" do
          log_times = set_up_log_time_entries
          expect(@mock_log_time_repo).
            to receive(:sorted_current_month_entries_by_employee_id).
            with(@employee_id).
            and_return(log_times)
          expect(@report_retrieval.log_times).to eq(log_times)
        end
      end

      context "the employee_id 1 has no log times" do
        it "returns nil" do
          expect(@mock_log_time_repo).
            to receive(:sorted_current_month_entries_by_employee_id).
            with(@employee_id).
            and_return(nil)
          expect(@report_retrieval.log_times).to eq(nil)
        end
      end
    end

    describe ".convert_log_time_objects_to_strings" do
      context "log time objects exist for employee 1" do 
        it "returns a 2D array of strings that correspond to their log times" do
          log_times_objects = set_up_log_time_entries
          log_times_array = 
            [
              ["9-3-2016", "6", "Non-Billable", nil],
              ["9-4-2016", "8", "PTO", nil],
              ["9-6-2016", "7", "Billable", "Google"],
            ]
          result = @report_retrieval.
            convert_log_time_objects_to_strings(log_times_objects)
          expect(result).to eq(log_times_array)
        end
      end
    end

    describe ".client_hours" do
      it "returns a hash of hours worked per client" do
        clients_hash = { "Google": 7 } 

        expect(@mock_log_time_repo).
          to receive(:employee_client_hours).
          with(@employee_id).
          and_return(clients_hash)
        result = @report_retrieval.client_hours
        expect(result).to eq(clients_hash)
      end
    end

    describe ".timecode_hours" do
      it "returns a hash of hours worked per timecode" do
        timecode_hash = 
          { 
            "Non-Billable": "6",
            "Billable": "7",
            "PTO": "8"
          }
        expect(@mock_log_time_repo).
          to receive(:employee_timecode_hours).
          with(@employee_id).
          and_return(timecode_hash)
        result = @report_retrieval.timecode_hours
        expect(result).to eq(timecode_hash)
      end
    end

    describe ".company_wide_timecode_hours" do
      it "returns a hash of total hours worked per timecode" do
        company_timecode_hash = 
          {
            "Billable" => 4, 
            "Non-Billable" => 6,
            "PTO" => 5
          }
        expect(@mock_log_time_repo).
          to receive(:company_timecode_hours).
          and_return(company_timecode_hash)
        result = @report_retrieval.company_wide_timecode_hours
        expect(result).to eq(company_timecode_hash)
      end
    end

    describe ".company_wide_client_hours" do
      it "returns a hash of total hours worked per client" do
        company_client_hash =  
          { 
            "Microsoft" => 5,
            "Google" => 3
          }
        expect(@mock_log_time_repo).
          to receive(:company_client_hours).
          and_return(company_client_hash)
        result = @report_retrieval.company_wide_client_hours
        expect(result).to eq(company_client_hash)
      end
    end
  end
end
