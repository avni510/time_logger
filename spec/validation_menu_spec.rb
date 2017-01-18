module TimeLogger
  require "spec_helper"

  describe ValidationMenu do
    let (:validation_menu) { ValidationMenu.new }

    describe ".validate" do
      it "returns an instance of the result object with the proper errors" do
        valid_menu_option_message = "Please enter a valid option"

        timecode_hash = 
          {
            "1": "Billable", 
            "2": "Non-Billable", 
            "3": "PTO", 
          }
        login_menu_hash = 
          {
            "1": "1. Do you want to log your time?", 
            "2": "2. Do you want to run a report on yourself?", 
            "3": "3. Quit the program"
          }
        [               
          [timecode_hash, "1", nil],
          [timecode_hash, "4", valid_menu_option_message],
          [login_menu_hash, "T", valid_menu_option_message],
          [login_menu_hash, "!", valid_menu_option_message],
          [login_menu_hash, "3", nil],
        ].each do |hash, user_input, value|
          result = validation_menu.validate(hash, user_input)
          expect(result.error_message).to eq(value)
        end
      end
    end
  end
end
