module TimeLogger
  require "spec_helper"
  output_file_name = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"
  
  describe Employee do

    before(:each) do 
      @mock_save_data = double
      @mock_console_ui = double
      allow(@mock_save_data).to receive(:add_username).with("avnik")
      @employee = Employee.new("avnik", @mock_save_data, @mock_console_ui)
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
       allow(@mock_console_ui).to receive(:date_log_time_message)
     end

     it "allows the user to enter the date of when they want to log time for" do
      expect(@mock_console_ui).to receive(:date_log_time_message)
#      expect(@mock_save_data).to receive(:add_date_logged)

      @employee.log_time 
     end
   end

#    it "allows the user to enter how many hours worked" do
#      expect(@mock_console_ui).to receive(:hours_log_time_message)
#      @employee.log_time
#    end
#
#    it "allows the user to enter the type of work" do
#    end
#
#
#    it "doesn't allow the user to select a date in the future" do
#    end
#
#    it "doesn't allow the user to enter more than 24 hours" do
#    end

  end
end
