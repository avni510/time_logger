require "spec_helper"
module TimeLogger
  module Console

    describe EmployeeSetup do
      before(:each) do
        @employee_1 = TimeLogger::Employee.new(1, "rstarr", false)
        @mock_console_ui = double  
        @mock_employee_repo = double
        @worker_setup = EmployeeSetup.new(@mock_console_ui)
        allow(Repository).to receive(:for).and_return(@mock_employee_repo)
      end

      describe ".run" do
        it "prompts the user for their username" do
          expect(@mock_console_ui).to receive(:username_display_message)
          expect(@mock_console_ui).to receive(:get_user_input).and_return("rstarr")
          expect(@mock_employee_repo).to receive(:find_by_username).with("rstarr").and_return(@employee_1)
          expect_any_instance_of(MenuSelection).to receive(:run)
          @worker_setup.run
        end

        context "the user does not exist in the data" do
          it "displays a message of an invalid username and prompts them to enter the username again" do
            allow(@mock_console_ui).to receive(:username_display_message)
            expect(@mock_console_ui).to receive(:get_user_input).and_return("jlennon", "rstarr")
            expect(@mock_employee_repo).to receive(:find_by_username).and_return(nil, @employee_1)
            expect(@mock_console_ui).to receive(:username_does_not_exist_message)
            expect_any_instance_of(MenuSelection).to receive(:run)
            @worker_setup.run
          end
        end
      end
    end
  end
end
