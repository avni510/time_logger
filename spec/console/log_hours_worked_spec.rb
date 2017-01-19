module TimeLogger
  module Console
    require "spec_helper"

    describe LogHoursWorked do
      let(:mock_console_ui) { double }
      let(:mock_log_time_repo) { double }
      let(:validation_log_time) { 
        TimeLogger::ValidationLogTime.new(
          TimeLogger::ValidationDate.new, 
          TimeLogger::ValidationHoursWorked.new, 
          mock_log_time_repo)
      }
      let(:log_hours_worked) { LogHoursWorked.new(mock_console_ui, validation_log_time) }

      describe ".run" do 
        before(:each) do
          @employee_id = 1
          @date_entered = "01-01-2017"
          allow(mock_log_time_repo).to receive(:find_total_hours_worked_for_date).
            with(@employee_id, @date_entered).and_return(0)
        end

        it "allows the user to enter the hour they worked" do
          expect(mock_console_ui).to receive(:hours_log_time_message).and_return("8")
          expect(log_hours_worked.run(@employee_id, @date_entered)).to eq("8")
        end

        context "the hours entered is a non digit" do
          it "prompts the user to enter a digit" do
            expect(mock_console_ui).to receive(:hours_log_time_message).and_return("!")
            expect(mock_console_ui).to receive(:puts_string).with("Please enter a number greater than 0")
            expect(mock_console_ui).to receive(:get_user_input).and_return("8")
            expect(log_hours_worked.run(@employee_id, @date_entered)).to eq("8")
          end
        end

        context " a digit is entered for hours worked and more than 24 hours were logged for a specific date" do
          it "prompts the user to enter a valid number of hours" do
            expect(mock_log_time_repo).to receive(:find_total_hours_worked_for_date).
              with(@employee_id, @date_entered).and_return(20)
            expect(mock_console_ui).to receive(:hours_log_time_message).and_return("5")
            expect(mock_console_ui).to receive(:puts_string).with("You have exceeded 24 hours for this day.")
            value = log_hours_worked.run(@employee_id, @date_entered)
            expect(value).to eq(nil)
          end
        end
      end
    end
  end
end
