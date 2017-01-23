module TimeLogger
  module Console
    require "spec_helper"

    describe EmployeeCreation do
      before(:each) do
        @mock_console_ui = double
        @mock_employee_repo = double
        validation_employee_creation = TimeLogger::ValidationEmployeeCreation.new(@mock_employee_repo)
        validation_menu = TimeLogger::ValidationMenu.new
        @employee_creation = EmployeeCreation.new(@mock_console_ui, validation_employee_creation, validation_menu)
        allow(Repository).to receive(:for).and_return(@mock_employee_repo)
        allow(@mock_employee_repo).to receive(:create)
        allow(@mock_employee_repo).to receive(:save)
      end

      describe ".execute" do
        before(:each) do
          allow(@mock_console_ui).to receive(:enter_new_username_message)
          allow(@mock_console_ui).to receive(:create_admin_message)
          allow(@mock_console_ui).to receive(:display_menu_options)
        end

        context "the user enters a username that does not exist and a valid option for an admin" do
          it "prompts the user to create a new employee and saves it" do
            expect(@mock_console_ui).to receive(:enter_new_username_message)
            expect(@mock_console_ui).to receive(:get_user_input).and_return("pmccartney", "1")
            allow(@mock_employee_repo).to receive(:find_by_username).and_return(nil)
            expect(@mock_console_ui).to receive(:create_admin_message)
            admin_options_hash = {
              "1": "1. yes",
              "2": "2. no"
            }
            expect(@mock_console_ui).to receive(:display_menu_options).with(admin_options_hash)
            expect(@mock_employee_repo).to receive(:create).with("pmccartney", true)
            expect(@mock_employee_repo).to receive(:save)
            @employee_creation.execute
          end
        end

        context "the user enters 'rstarr' who exists as a user" do
          it "prompts the user to create a different user name" do
            expect(@mock_console_ui).to receive(:get_user_input).and_return("rstarr", "pmccartney", "2")
            allow(@mock_employee_repo).to receive(:find_by_username).and_return(TimeLogger::Employee.new(1, "rstarr", false), nil)
            expect(@mock_console_ui).to receive(:puts_string).with("This user already exists, please enter a different one")
            @employee_creation.execute
          end
        end

        context "the user enters a blank space" do
          it "prompts the user to create a different user name" do
            expect(@mock_console_ui).to receive(:get_user_input).and_return("", "pmccartney", "2")
            expect(@mock_console_ui).to receive(:puts_string).with("Your input cannot be blank")
            allow(@mock_employee_repo).to receive(:find_by_username).and_return(nil)
            @employee_creation.execute
          end
        end

        context "the user enters an invalid admin option for the new username" do
          it "prompts the user to enter another admin option" do
            expect(@mock_console_ui).to receive(:get_user_input).and_return("pmccartney", "6", "2")
            allow(@mock_employee_repo).to receive(:find_by_username).and_return(nil)
            expect(@mock_console_ui).to receive(:puts_string).with("Please enter a valid option")
            @employee_creation.execute
          end
        end
      end
    end
  end
end
