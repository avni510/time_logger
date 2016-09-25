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
  end
end
