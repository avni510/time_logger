module TimeLogger
  require "spec_helper"

  describe WorkerSetup do
    before(:each) do
      @mock_employee_repo = double
      allow(Repository).to receive(:for).and_return(@mock_employee_repo)

      @mock_console_ui = double  
      @worker_setup = WorkerSetup.new(@mock_console_ui)
    end
    
    def setup_employee
      Employee.new(1, "rstarr", false)
    end

    describe ".run" do

      context "the user exists in the data" do
        it "prompts the user for their username" do
          expect(@mock_console_ui).to receive(:username_display_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("rstarr")

          employee_1 = setup_employee
          expect(@mock_employee_repo).to receive(:find_by_username).with("rstarr").and_return(employee_1)
          
          expect_any_instance_of(MenuSelection).to receive(:run)

          @worker_setup.run
        end
      end

      context "the user does exists in the data" do
        it "prompts the user for their username" do
          allow(@mock_console_ui).to receive(:username_display_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("jlennon", "rstarr")

          employee_1 = setup_employee

          expect(@mock_employee_repo).to receive(:find_by_username).with("jlennon").and_return(nil)

          expect(@mock_console_ui).to receive(:username_does_not_exist_message)

          expect(@mock_employee_repo).to receive(:find_by_username).with("rstarr").and_return(employee_1)

          expect_any_instance_of(MenuSelection).to receive(:run)

          @worker_setup.run
        end
      end
    end
  end
end
