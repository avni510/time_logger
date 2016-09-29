module TimeLogger
  output_file = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"
  require "spec_helper"
  
  describe Report do
    before(:each) do
      @mock_console_ui = double 
      @report = Report.new(@mock_console_ui) 

      @repositories_hash = 
        {
          "log_time": double, 
        }
      @repository = Repository.new(@repositories_hash)
      @mock_log_time_repo = @repository.for(:log_time)
    end

    def set_up_log_time_entries
      params_entry_1 = 
        { 
          "id": 1, 
          "employee_id": 1, 
          "date": "09-06-2016", 
          "hours_worked": "6", 
          "timecode": "Non-Billable", 
          "client": nil 
        }
      params_entry_2 = 
        { 
          "id": 2, 
          "employee_id": 1, 
          "date": "09-04-2016", 
          "hours_worked": "8", 
          "timecode": "PTO", 
          "client": nil 
        }

      params_entry_3 = 
        { 
          "id": 3, 
          "employee_id": 1, 
          "date": "09-03-2016", 
          "hours_worked": "7", 
          "timecode": "Billable", 
          "client": "Google"
        }

      log_times = 
        [
          LogTimeEntry.new(params_entry_1),
          LogTimeEntry.new(params_entry_2),
          LogTimeEntry.new(params_entry_3),
        ]

      expect(@mock_log_time_repo).to receive(:find_log_times_by).and_return(log_times)
    end
    
    describe ".execute" do
      context "the username 'rstarr' exists with log times" do
        it "returns a report of sorted log times, total client hours, and total timecode" do
          set_up_log_time_entries

          sorted_log_times_array = 
            [
              ["09-03-2016", "7", "Billable", "Google"],
              ["09-04-2016", "8", "PTO", nil],
              ["09-06-2016", "6", "Non-Billable", nil],
            ]

          clients_hash = { "Google": "7" } 
          clients_hash = JSON.parse(JSON.generate(clients_hash))

          timecode_hash = 
            { 
              "Non-Billable": "6",
              "Billable": "7",
              "PTO": "8"
            }
          
          timecode_hash = JSON.parse(JSON.generate(timecode_hash))
          expect(@mock_console_ui).to receive(:format_employee_self_report).with(sorted_log_times_array, clients_hash, timecode_hash)

          employee_id = 1
          result = @report.execute(employee_id, @repository)
        end
      end
    end
  end
end
