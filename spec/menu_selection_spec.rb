module TimeLogger
  require "spec_helper"

  describe MenuSelection do
    let(:mock_console_ui) { double }

    before(:each) do
      @employee = Employee.new(1, "rstarr", false)
      @admin_employee = Employee.new(2, "jlennon", true)

      allow(mock_console_ui).to receive(:menu_selection_message)
      allow(mock_console_ui).to receive(:display_menu_options)
    end

    describe ".run" do
      let(:menu_selection) { MenuSelection.new(@employee, mock_console_ui) }

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

      context "the employee is an admin" do
        let(:menu_selection) { MenuSelection.new(@admin_employee, mock_console_ui) }
        
        it "displays a menu with more options" do

          expect(mock_console_ui).to receive(:menu_selection_message)

          menu_options_hash = 
            { 
              "1": "1. Do you want to log your time?", 
              "2": "2. Do you want to run a report on yourself?",
              "3": "3. Quit the program", 
              "4": "4. Do you want to create a client?", 
              "5": "5. Do you want to create an employee?", 
              "6": "6. Do you want to run a company report?"
            }

          expect(mock_console_ui).to receive(:display_menu_options).with(menu_options_hash)

          expect(mock_console_ui).to receive(:get_user_input).and_return("3")

          menu_selection.run
        end

        context "the user selects the option to create a client" do
          it "runs the action of creating a client" do

            expect(mock_console_ui).to receive(:get_user_input).and_return("4", "3")

            expect_any_instance_of(ClientCreation).to receive(:execute)

            menu_selection.run
          end
        end

        context "the user selects the option to create an employee" do
          it "runs the action of creating a client" do

            expect(mock_console_ui).to receive(:get_user_input).and_return("5", "3")

            expect_any_instance_of(EmployeeCreation).to receive(:execute)

            menu_selection.run
          end
        end

        context "the user selects the option to run an admin report" do
          it "runs the action of running a report" do

            expect(mock_console_ui).to receive(:get_user_input).and_return("6", "3")

            expect_any_instance_of(AdminReport).to receive(:execute)

            menu_selection.run
          end
        end
      end
    end
  end
end
