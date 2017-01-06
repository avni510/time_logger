module TimeLogger
  require "spec_helper"
  
  describe EmployeeReport do
    before(:each) do
      @mock_console_ui = double 
      @employee_id = 1
      @employee_report = EmployeeReport.new(@mock_console_ui, @employee_id)
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
    
    describe ".execute" do
      context "the employee_id 1 exists with log times and the current month is September" do
        it "returns a report of the current month of sorted log times, total client hours, and total timecode" do
          log_times_objects = set_up_log_time_entries
          expect_any_instance_of(ReportRetrieval).
            to receive(:log_times).
            and_return(log_times_objects)
          sorted_log_times_array = 
            [
              ["9-3-2016", "6", "Non-Billable", nil],
              ["9-4-2016", "8", "PTO", nil],
              ["9-6-2016", "7", "Billable", "Google"],
            ]
          expect_any_instance_of(ReportRetrieval).
            to receive(:convert_log_time_objects_to_strings).
            and_return(sorted_log_times_array)
          clients_hash = { "Google": 7 } 
          expect_any_instance_of(ReportRetrieval).
            to receive(:client_hours).
            and_return(clients_hash)
          timecode_hash = 
            { 
              "Non-Billable": "6",
              "Billable": "7",
              "PTO": "8"
            }
          expect_any_instance_of(ReportRetrieval).
            to receive(:timecode_hours).
            and_return(timecode_hash)
          expect(@mock_console_ui).
            to receive(:format_employee_report).
            with(sorted_log_times_array, clients_hash, timecode_hash)
          @employee_report.execute
        end
      end

      context "the employee exists with no log times" do
        it "displays a message to the user that there are no log times" do
          expect_any_instance_of(ReportRetrieval).
            to receive(:log_times).
            and_return(nil)
          expect(@mock_console_ui).to receive(:no_log_times_message)
          @employee_report.execute
        end
      end
    end
  end
end
