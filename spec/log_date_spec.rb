module TimeLogger
  require "spec_helper"

  describe LogDate do
    let(:mock_console_ui) { double }
    let(:validation) { Validation.new }
    let(:log_date) { LogDate.new(mock_console_ui, validation) }

    describe ".run" do 
      it "allows the user to enter the date they worked" do
        expect(mock_console_ui).to receive(:date_log_time_message).and_return("09-15-2016")

        log_date.run
      end

      context "the date entered is not a date from the calendar" do
        it "prompts the user to enter a valid date" do
          expect(mock_console_ui).to receive(:date_log_time_message).and_return("06-31-2016")

          expect(mock_console_ui).to receive(:valid_date_message)

          expect(mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")
          
          log_date.run
        end
      end

      context "the date entered is in the future" do
        it "prompts the user to enter a previous date" do
          expect(mock_console_ui).to receive(:date_log_time_message).and_return("11-20-2016")

          expect(mock_console_ui).to receive(:future_date_valid_message)

          expect(mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")

          log_date.run
        end
      end

      it "returns a string of the date entered" do
        expect(mock_console_ui).to receive(:date_log_time_message).and_return("09-15-2016")

        result = log_date.run 
        expect(result).to eq("09-15-2016")
      end
    end
  end
end
