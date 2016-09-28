module TimeLogger
  output_file = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"

  require "spec_helper"

  # create a method to set up an employee rather than having it in a before block
  
  describe Report do
    before(:each) do

      @repositories_hash = 
        {
          "log_time": double, 
        }
      @repository = Repository.new(@repositories_hash)
      @mock_save_json_data = double
      @mock_console_ui = double 
      @report = Report.new(@mock_console_ui) 
    end
    
    describe ".execute" do
      before(:each) do
        @mock_log_time_repo = @repositories_hash[:log_time]
      end

      context "the username 'rstarr' exists with log times" do
        before(:each) do
          employee_repo = EmployeeRepo.new(@mock_save_json_data)

          username = "rstarr"
          admin = false

          employee_repo.create(username, admin)

          @employee_1 = employee_repo.employees[0]

          @log_time_repo = LogTimeRepo.new(@mock_save_json_data)

          @log_time_repo.create(@employee_1.id, "09-06-2016", "6", "Non-Billable")

          @log_time_repo.create(@employee_1.id, "09-04-2016", "8", "PTO")

          @log_time_repo.create(@employee_1.id, "09-03-2016", "7", "Billable", "Google")
        end

        it "returns a report of sorted log times, total client hours, and total timecode" do

          unsorted_log_times = @log_time_repo.find_log_times_by(@employee_1.id)

          expect(@mock_log_time_repo).to receive(:find_log_times_by).with(@employee_1.id).and_return(unsorted_log_times)


          sorted_log_times = unsorted_log_times.sort_by{ |log_time_entry| log_time_entry.date }

          sorted_log_times_array = []
          sorted_log_times.each do |log_time_entry|
            log_time_entry_array = 
              [ 
                log_time_entry.date,
                log_time_entry.hours_worked,
                log_time_entry.timecode,
                log_time_entry.client
              ]
            sorted_log_times_array << log_time_entry_array
          end
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

          result = @report.execute(@employee_1.id, @repository)
        end
      end
    end
  end
end
