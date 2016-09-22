module TimeLogger
  require "spec_helper"
  output_file_name = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"
  
  describe Employee do

    before(:each) do 
      @mock_save_data = double
      @mock_console_ui = double
      @validation = Validation.new
      allow(@mock_save_data).to receive(:add_username).with("avnik")
      @employee = Employee.new("avnik", @mock_save_data, @mock_console_ui, @validation)
    end

    it "creates a new Employee" do
      expect(@employee.username).to eq("avnik")
    end

    describe ".menu_messages" do
      it "displays the beginning messages after an employee logins"do
        expect(@mock_console_ui).to receive(:menu_selection_message)
        menu_options_hash = 
          { 
            "1": "1. Do you want to log your time?", 
            "2": "2. Do you want to run a report on yourself?",
            "3": "3. Quit the program"
          }

        expect(@mock_console_ui).to receive(:display_menu_options).with(menu_options_hash)
        expect(@mock_console_ui).to receive(:get_user_input).exactly(1).times

        @employee.menu_messages
      end
    end

    describe ".log_time" do
      before(:each) do
        allow(@mock_console_ui).to receive(:date_log_time_message).and_return("09-12-2016")
        allow(@mock_console_ui).to receive(:hours_log_time_message).and_return("7")
        allow(@mock_console_ui).to receive(:timecode_log_time_message).and_return("1")

        allow(@mock_save_data).to receive(:add_logged_time)
      end

      context "all fields entered are valid" do
        it "allows the user to enter the date, hours worked, and timecode" do

        expect(@mock_console_ui).to receive(:date_log_time_message).and_return("09-15-2016")
        expect(@mock_console_ui).to receive(:hours_log_time_message).and_return("8")

        timecode_hash = 
        { 
          "1": "Billable", 
          "2": "Non-Billabe",
          "3": "PTO"
        }

        expect(@mock_console_ui).to receive(:timecode_log_time_message).with(timecode_hash)

        expect(@mock_save_data).to receive(:add_logged_time)

        @employee.log_time 
        end
      end

     context "the date entered is invalid" do
       it "prompts the user to enter a valid date" do
         expect(@mock_console_ui).to receive(:date_log_time_message).and_return("06-31-2016")

         expect(@mock_console_ui).to receive(:valid_date_message)
         expect(@mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")

         @employee.log_time
       end
     end

     context "the date entered is in the future" do
       it "prompts the user to enter a previous date" do
         expect(@mock_console_ui).to receive(:date_log_time_message).and_return("11-20-2016")

         expect(@mock_console_ui).to receive(:future_date_valid_message)
         expect(@mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")

         @employee.log_time
       end
     end

     context "more than 24 hours were logged for a specific date" do
       it "prompts the user to enter a valid number of hours" do

        expect(@mock_console_ui).to receive(:hours_log_time_message).and_return("30")

        expect(@mock_console_ui).to receive(:valid_hours_message)

        expect(@mock_console_ui).to receive(:get_user_input).and_return("3")

        @employee.log_time
       end
     end

     context "an invalid timecode is entered" do
       it "prompts the user to enter a menu option" do

        expect(@mock_console_ui).to receive(:timecode_log_time_message).and_return("4")

        expect(@mock_console_ui).to receive(:valid_menu_option_message)

        expect(@mock_console_ui).to receive(:get_user_input).and_return("3")

        @employee.log_time
       end
     end
   end
  end
end
