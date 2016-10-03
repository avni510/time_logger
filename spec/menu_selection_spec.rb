module TimeLogger
  require "spec_helper"

  describe MenuSelection do
    let(:mock_console_ui) { double }
    let(:menu_selection) { MenuSelection.new(@employee, mock_console_ui) }

    before(:each) do
      @employee = Employee.new(1, "rstarr", false)

      allow(mock_console_ui).to receive(:menu_selection_message)
      allow(mock_console_ui).to receive(:display_menu_options)
    end

    describe ".run" do
      it "displays the beginning messages after an employee logins"do
        expect(mock_console_ui).to receive(:menu_selection_message)
        menu_options_hash = 
          { 
            "1": "1. Do you want to log your time?", 
            "2": "2. Do you want to run a report on yourself?",
            "3": "3. Quit the program"
          }

        expect(mock_console_ui).to receive(:display_menu_options).with(menu_options_hash)
        expect(mock_console_ui).to receive(:get_user_input).and_return("3")

        menu_selection.run
      end

      context "the option to log time is selected" do
        it "runs the action of logging time" do
          expect(mock_console_ui).to receive(:get_user_input).and_return("1", "3")

          allow_any_instance_of(LogTime).to receive(:execute)

          menu_selection.run
        end
      end

      context "the option to run a report is selected" do
        it "runs the action of displaying a report" do
          expect(mock_console_ui).to receive(:get_user_input).and_return("2", "3")

          allow_any_instance_of(EmployeeReport).to receive(:execute)

          menu_selection.run
        end
      end

      context "the user has already selected either log time or run a report" do
        it "displays the menu again" do
          expect(mock_console_ui).to receive(:display_menu_options).exactly(3).times

          expect(mock_console_ui).to receive(:get_user_input).and_return("2", "1", "3")

          allow_any_instance_of(EmployeeReport).to receive(:execute)

          allow_any_instance_of(LogTime).to receive(:execute)

          menu_selection.run
        end
      end

      context "the user enters an invalid menu option" do
        it "prompts the user to enter a valid menu option" do
          expect(mock_console_ui).to receive(:display_menu_options)

          expect(mock_console_ui).to receive(:get_user_input).and_return("!", "3")
          expect(mock_console_ui).to receive(:valid_menu_option_message)

          menu_selection.run
        end
      end
    end
  end
end
