module TimeLogger
  module Console
    require "spec_helper"

    describe LogHoursWorked do
      let(:mock_console_ui) { double }
      let(:validation) { TimeLogger::Validation.new }
      let(:log_hours_worked) { LogHoursWorked.new(mock_console_ui, validation) }

      describe ".run" do 
        before(:each) do
          @previous_hours_worked = 0
        end

        it "allows the user to enter the hour they worked" do
          expect(mock_console_ui).to receive(:hours_log_time_message).and_return("8")

          log_hours_worked.run(@previous_hours_worked)
        end

        context "the hours entered is a non digit" do
          it "prompts the user to enter a digit" do

            expect(mock_console_ui).to receive(:hours_log_time_message).and_return("!")

            expect(mock_console_ui).to receive(:enter_digit_message)

            expect(mock_console_ui).to receive(:get_user_input).and_return("8")

            log_hours_worked.run(@previous_hours_worked)
          end
        end

        context " a digit is entered for hours worked and more than 24 hours were logged for a specific date" do
          it "prompts the user to enter a valid number of hours" do

            allow(mock_console_ui).to receive(:hours_log_time_message).and_return("5")

            expect(mock_console_ui).to receive(:valid_hours_message)

            @previous_hours_worked = 20
            result = log_hours_worked.run(@previous_hours_worked)
            expect(result).to eq(nil)
          end
        end

        it "returns the hours worked that the user enters" do
          expect(mock_console_ui).to receive(:hours_log_time_message).and_return("5")

          result = log_hours_worked.run(@previous_hours_worked)

          expect(result).to eq("5")
        end
      end
    end
  end
end
