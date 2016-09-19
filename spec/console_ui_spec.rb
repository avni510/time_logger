module TimeLogger
  require "spec_helper"

  describe ConsoleUI do
    let(:mock_ui_wrapper) { double }
    let(:console_ui) { ConsoleUI.new(mock_ui_wrapper) }

    it "asks the user for their username" do
      expect(mock_ui_wrapper).to receive(:puts_string).with("Please enter your username")
      console_ui.username_display_message
    end

    it "prompts the user for input" do
      expect(mock_ui_wrapper).to receive(:get_action).exactly(1).times
      console_ui.get_user_input
    end

    it "displays a space" do
      expect(mock_ui_wrapper).to receive(:puts_string).with("")
      console_ui.puts_space
    end

    context "an invalid username is entered" do
      it "asks the user to enter a valid username" do
        expect(mock_ui_wrapper).to receive(:puts_string).with("Please enter a valid username")
        console_ui.valid_username_message
      end
    end

    context "an invalid menu option is selected" do
      it "asks the user to enter a valid menu option" do
        expect(mock_ui_wrapper).to receive(:puts_string).with("Please enter a valid menu option")
        console_ui.valid_menu_option_message
      end
    end


    it "displays the menu options" do
      employee_menu_options = 
        {
          "1" => "1. Do you want to log your time?", 
          "2" => "2. Do you want to run a report for the current month?" 
        }

      expect(mock_ui_wrapper).to receive(:puts_string).exactly(2).times
      expect(console_ui).to receive(:puts_space)
      console_ui.display_menu_options(employee_menu_options)
    end
  end
end
