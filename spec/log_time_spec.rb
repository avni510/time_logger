module TimeLogger
  require 'spec_helper'

  describe LogTime do
    before(:each) do
      @mock_save_data = double
      @mock_console_ui = double
      @validation = Validation.new
      @log_time = LogTime.new(@mock_save_data, @mock_console_ui, @validation)
      @username = "avnik"
    end

    describe ".log_time" do
      before(:each) do
        allow(@mock_console_ui).to receive(:date_log_time_message).and_return("09-12-2016")
        allow(@mock_console_ui).to receive(:hours_log_time_message).and_return("7")
        allow(@mock_console_ui).to receive(:timecode_log_time_message).and_return("2")

        allow(@mock_save_data).to receive(:add_logged_time)
      end

      context "all fields entered are valid" do
        it "allows the user to enter the date, hours worked, and timecode" do

        expect(@mock_console_ui).to receive(:date_log_time_message).and_return("09-15-2016")
        expect(@mock_console_ui).to receive(:hours_log_time_message).and_return("8")

        timecode_hash = 
        { 
          "1": "1. Billable", 
          "2": "2. Non-Billable",
          "3": "3. PTO"
        }

        expect(@mock_console_ui).to receive(:timecode_log_time_message).with(timecode_hash)

        expect(@mock_save_data).to receive(:add_logged_time)

        @log_time.execute(@username)
        end
      end

      context "the date entered is invalid" do
        it "prompts the user to enter a valid date" do
          expect(@mock_console_ui).to receive(:date_log_time_message).and_return("06-31-2016")

          expect(@mock_console_ui).to receive(:valid_date_message)
          expect(@mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")

          @log_time.execute(@username)
        end
      end

      context "the date entered is in the future" do
        it "prompts the user to enter a previous date" do
          expect(@mock_console_ui).to receive(:date_log_time_message).and_return("11-20-2016")

          expect(@mock_console_ui).to receive(:future_date_valid_message)
          expect(@mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")

          @log_time.execute(@username)
        end
      end

      context "more than 24 hours were logged for a specific date" do
        it "prompts the user to enter a valid number of hours" do

          expect(@mock_console_ui).to receive(:hours_log_time_message).and_return("30")

          expect(@mock_console_ui).to receive(:valid_hours_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("3")

          @log_time.execute(@username)
        end
      end

      context "an invalid timecode is entered" do
        it "prompts the user to enter a menu option" do

          expect(@mock_console_ui).to receive(:timecode_log_time_message).and_return("4")

          expect(@mock_console_ui).to receive(:valid_menu_option_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("3")

          @log_time.execute(@username)
        end
      end

      it "passes in the correct data to be saved" do

        expect(@mock_console_ui).to receive(:date_log_time_message).and_return("04-15-2016")

        expect(@mock_console_ui).to receive(:hours_log_time_message).and_return("8")

        expect(@mock_console_ui).to receive(:timecode_log_time_message).and_return("2")

        expect(@mock_save_data).to receive(:add_logged_time).with("avnik", "04-15-2016", "8", "Non-Billable")

        @log_time.execute(@username)
      end
    end
  end
end
