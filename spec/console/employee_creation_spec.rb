module TimeLogger
  module Console
    require "spec_helper"

    describe EmployeeCreation do
      before(:each) do
        @mock_console_ui = double
        validation = TimeLogger::Validation.new
        @employee_creation = EmployeeCreation.new(@mock_console_ui, validation)
      end

      describe ".execute" do
        before(:each) do
          allow(@mock_console_ui).to receive(:enter_new_username_message)
          allow(@mock_console_ui).to receive(:create_admin_message)
          allow(@mock_console_ui).to receive(:display_menu_options)

          allow_any_instance_of(TimeLogger::WorkerRetrieval).to receive(:save_employee)
        end

        context "the user enters a username that does not exist and a valid option for an admin" do
          it "prompts the user to create a new employee and saves it" do
            expect(@mock_console_ui).to receive(:enter_new_username_message)
            expect(@mock_console_ui).to receive(:get_user_input).and_return("pmccartney", "1")
            
            expect_any_instance_of(TimeLogger::WorkerRetrieval).to receive(:employee).and_return(nil)

            expect(@mock_console_ui).to receive(:create_admin_message)

            admin_options_hash = {
              "1": "1. yes",
              "2": "2. no"
            }

            expect(@mock_console_ui).to receive(:display_menu_options).with(admin_options_hash)

            expect_any_instance_of(TimeLogger::WorkerRetrieval).to receive(:save_employee).with("pmccartney", true)

            @employee_creation.execute
          end
        end

        context "the user enters 'rstarr' who exists as a user" do
          it "prompts the user to create a different user name" do
            expect(@mock_console_ui).to receive(:get_user_input).and_return("rstarr", "pmccartney", "2")

            expect_any_instance_of(TimeLogger::WorkerRetrieval).to receive(:employee).and_return(TimeLogger::Employee.new(1, "rstarr", false), nil)
            expect(@mock_console_ui).to receive(:username_exists_message).exactly(1).times

            @employee_creation.execute
          end
        end

        context "the user enters a blank space" do
          it "prompts the user to create a different user name" do
            expect(@mock_console_ui).to receive(:get_user_input).and_return("", "pmccartney", "2")

            expect(@mock_console_ui).to receive(:valid_username_message)

            expect_any_instance_of(TimeLogger::WorkerRetrieval).to receive(:employee).with("pmccartney").and_return(nil)

            @employee_creation.execute
          end
        end

        context "the user enters an invalid admin option for the new username" do
          it "prompts the user to enter another admin option" do
            expect(@mock_console_ui).to receive(:get_user_input).and_return("pmccartney", "6", "2")

            expect_any_instance_of(TimeLogger::WorkerRetrieval).to receive(:employee).with("pmccartney").and_return(nil)
            
            expect(@mock_console_ui).to receive(:valid_menu_option_message).exactly(1).times

            @employee_creation.execute
          end
        end
      end
    end
  end
end
