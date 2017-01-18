module TimeLogger
  module Console
    require 'spec_helper'

    describe LogTime do
      let(:mock_console_ui) { double }
      let(:validation_hours_worked) { TimeLogger::ValidationHoursWorked.new }
      let(:validation_menu) { TimeLogger::ValidationMenu.new }
      let(:validation_date) { TimeLogger::ValidationDate.new } 
      let(:client_repo) { double }
      let(:employee_repo) { double }
      let(:validation_client_creation) { TimeLogger::ValidationClientCreation.new(client_repo) }
      let(:validation_employee_creation) { TimeLogger::ValidationEmployeeCreation.new(employee_repo) }
      let(:log_date) { LogDate.new(mock_console_ui, validation_date) }
      let(:log_hours_worked) { LogHoursWorked.new(mock_console_ui, validation_hours_worked) }
      let(:log_timecode) { LogTimecode.new(mock_console_ui, validation_menu) }
      let(:log_client) { LogClient.new(mock_console_ui, validation_menu) }

      let(:params) {
        { :log_date => log_date,
          :log_hours_worked => log_hours_worked,
          :log_timecode => log_timecode,
          :log_client => log_client,
          :employee_id => 1
        }}

      let(:log_time) { LogTime.new(params) }

      before(:each) do
        @employee_id = 1
        @clients = [
            TimeLogger::Client.new(1, "Microsoft"),
            TimeLogger::Client.new(2, "Facebook")
          ]
      end

      before(:each) do
        allow(log_date).
          to receive(:run).
          and_return("09-15-2016")  
        previous_hours_worked = 0
        allow_any_instance_of(TimeLogger::LogTimeRetrieval).
          to receive(:employee_hours_worked_for_date).
          with(@employee_id, "09-15-2016").
          and_return(previous_hours_worked)
        allow(log_hours_worked).
          to receive(:run).
          with(previous_hours_worked).
          and_return("5")
        allow_any_instance_of(TimeLogger::LogTimeRetrieval).
          to receive(:all_clients).
          and_return(@clients)
        allow(log_timecode).to receive(:run).
          with(@clients).
          and_return("Non-Billable")
        allow_any_instance_of(TimeLogger::LogTimeRetrieval).
          to receive(:save_log_time_entry).
          with(
            @employee_id,
            "09-15-2016",
            "5",
            "Non-Billable",
            nil)
      end

      describe ".execute" do
        context "the user does not select 'Billable' as their timecode" do
          it "allows the user to log their time" do
            expect(log_date).to receive(:run).and_return("09-15-2016")  
            previous_hours_worked = 0
            expect_any_instance_of(TimeLogger::LogTimeRetrieval).
              to receive(:employee_hours_worked_for_date).
              with(@employee_id, "09-15-2016").
              and_return(previous_hours_worked)
            expect(log_hours_worked).
              to receive(:run).
              with(previous_hours_worked).
              and_return("5") 
            expect_any_instance_of(TimeLogger::LogTimeRetrieval).
              to receive(:all_clients).
              and_return(@clients)
            expect(log_timecode).to receive(:run).
              with(@clients).
              and_return("Non-Billable")
            expect_any_instance_of(TimeLogger::LogTimeRetrieval).
              to receive(:save_log_time_entry).
              with(
                @employee_id,
                "09-15-2016",
                "5",
                "Non-Billable",
                nil)
            log_time.execute
          end
        end

        context "the user selects 'Billable' as their timecode" do
          it "makes a call to select a client and saves it" do
            expect(log_timecode).to receive(:run).
              with(@clients).
              and_return("Billable")
            expect(log_client).to receive(:run).
              with(@clients).
              and_return("Google")
            expect_any_instance_of(TimeLogger::LogTimeRetrieval).
              to receive(:save_log_time_entry).
              with(
                @employee_id,
                "09-15-2016", 
                "5",
                "Billable", 
                "Google")
            log_time.execute
          end
        end

        context "hours_entered returns nil because the user has exceeded 24 hours for the date entered" do
          it "prompts the user to enter their date again" do
            allow(log_date).
              to receive(:run).
              and_return("09-15-2016", "09-16-2016")
            expect_any_instance_of(TimeLogger::LogTimeRetrieval).
              to receive(:employee_hours_worked_for_date).
              and_return(20, 0)
            expect(log_hours_worked).
              to receive(:run).
              and_return(nil, "5")
            expect_any_instance_of(TimeLogger::LogTimeRetrieval).
              to receive(:save_log_time_entry).
              with(
                @employee_id,
                "09-16-2016", 
                "5",
                "Non-Billable", 
                nil)
            log_time.execute
          end
        end
      end
    end
  end
end


