module TimeLogger
  require "spec_helper"

  describe WorkerSetup do
    before(:each) do
      @employee_1 = Employee.new(1, "rstarr", false)
      @mock_console_ui = double  
      @worker_setup = WorkerSetup.new(@mock_console_ui)
    end

    describe ".run" do
      it "prompts the user for their username" do
        expect(@mock_console_ui).to receive(:username_display_message)
        expect(@mock_console_ui).to receive(:get_user_input).and_return("rstarr")
        expect_any_instance_of(WorkerRetrieval).to receive(:run).and_return(@employee_1)
        expect_any_instance_of(MenuSelection).to receive(:run)
        @worker_setup.run
      end

      context "the user does not exist in the data" do
        it "displays a message of an invalid username and prompts them to enter the username again" do
          allow(@mock_console_ui).to receive(:username_display_message)
          expect(@mock_console_ui).to receive(:get_user_input).and_return("jlennon", "rstarr")
          expect_any_instance_of(WorkerRetrieval).to receive(:run).and_return(nil, @employee_1)
          expect(@mock_console_ui).to receive(:username_does_not_exist_message)
          expect_any_instance_of(MenuSelection).to receive(:run)
          @worker_setup.run
        end
      end
    end
  end
end
