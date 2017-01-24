module TimeLogger
  module Console
    require "spec_helper"

    describe LogDate do
      let(:mock_console_ui) { double }
      let(:mock_log_time_repo) { double }
      let(:validation_log_time) { 
        TimeLogger::ValidationLogTime.new(
          TimeLogger::ValidationDate.new, 
          TimeLogger::ValidationHoursWorked.new, 
          mock_log_time_repo)
      }
      let(:log_date) { LogDate.new(mock_console_ui, validation_log_time) }

      describe ".run" do 
        it "allows the user to enter the date they worked" do
          expect(mock_console_ui).to receive(:date_log_time_message).and_return("09-15-2016")

          expect(log_date.run).to eq("09-15-2016")
        end

        context "the date entered is not a date from the calendar" do
          it "prompts the user to enter a valid date" do
            expect(mock_console_ui).to receive(:date_log_time_message).and_return("06-31-2016")

            expect(mock_console_ui).to receive(:puts_string).with("Please enter a date in a valid format")

            expect(mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")
            
            expect(log_date.run).to eq("06-30-2016")
          end
        end

        context "the date entered is in the future" do
          it "prompts the user to enter a previous date" do
            expect(mock_console_ui).to receive(:date_log_time_message).and_return("11-20-2020")

            expect(mock_console_ui).to receive(:puts_string).with("Please enter a date in the past")

            expect(mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")

            expect(log_date.run).to eq("06-30-2016")
          end
        end
      end
    end
  end
end
