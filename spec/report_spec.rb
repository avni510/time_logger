module TimeLogger
  output_file = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"

  require "spec_helper"
  
  describe Report do
    let(:mock_retrieve_data) { double }
    let(:mock_console_ui) { double }
    let(:report) { Report.new(mock_retrieve_data, mock_console_ui) }
    
    describe ".self_summary" do
      context "the username 'kothari1' exists with log times" do
        it " returns an array of log times sorted" do

          log_times = [
            {
              "date": "09-06-2016",
              "hours_worked": "6", 
              "timecode": "Non-Billable",
              "client": nil
            },
            {
              "date": "09-07-2016",
              "hours_worked": "10", 
              "timecode": "Billable",
              "client": "Google"
            },
            {
              "date": "09-08-2016",
              "hours_worked": "5", 
              "timecode": "PTO",
              "client": nil
            },
            {
              "date": "09-04-2016",
              "hours_worked": "5", 
              "timecode": "Billable",
              "client": "Microsoft"
            },
            {
              "date": "09-02-2016",
              "hours_worked": "7", 
              "timecode": "Billable",
              "client": "Microsoft"
            }
          ]

          log_times_unsorted = JSON.parse(JSON.generate(log_times))

          expect(mock_retrieve_data).to receive(:user_log_times).with("kothari1").and_return(log_times_unsorted)

          log_times_sorted = [
            {
              "date": "09-02-2016",
              "hours_worked": "7", 
              "timecode": "Billable",
              "client": "Microsoft"
            },
            {
              "date": "09-04-2016",
              "hours_worked": "5", 
              "timecode": "Billable",
              "client": "Microsoft"
            },
            {
              "date": "09-06-2016",
              "hours_worked": "6", 
              "timecode": "Non-Billable",
              "client": nil
            },
            {
              "date": "09-07-2016",
              "hours_worked": "10", 
              "timecode": "Billable",
              "client": "Google"
            },
            {
              "date": "09-08-2016",
              "hours_worked": "5", 
              "timecode": "PTO",
              "client": nil
            }
          ]

          clients_hash = { "Microsoft": "12", "Google": "10" }

          timecode_hash = {"Billable": "22", "Non-Billable": "6", "PTO": "5"}

          log_times_sorted = JSON.parse(JSON.generate(log_times_sorted))

          clients_hash = JSON.parse(JSON.generate(clients_hash))

          timecode_hash = JSON.parse(JSON.generate(timecode_hash))

          expect(mock_console_ui).to receive(:format_employee_self_report).with(log_times_sorted, clients_hash, timecode_hash)

          report.self_summary("kothari1")
        end
      end
    end
  end
end
