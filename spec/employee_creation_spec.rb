module TimeLogger
  require "spec_helper"

  describe EmployeeCreation do
    before(:each) do
      repositories_hash = 
        {
          "employee": double
        }
      @repository = Repository.new(repositories_hash)
      @mock_employee_repo = @repository.for(:employee)

      @mock_console_ui = double
      validation = Validation.new
      @employee_creation = EmployeeCreation.new(@mock_console_ui, validation)
    end

    describe ".execute" do
      before(:each) do
        allow(@mock_console_ui).to receive(:enter_new_username_message)
        allow(@mock_console_ui).to receive(:create_admin_message)
        allow(@mock_console_ui).to receive(:display_menu_options)
        allow(@mock_employee_repo).to receive(:create)
        allow(@mock_employee_repo).to receive(:save)
      end

      context "all fields entered are valid" do
        it "prompts the user to create a new employee and saves it" do
          expect(@mock_console_ui).to receive(:enter_new_username_message)
          expect(@mock_console_ui).to receive(:get_user_input).and_return("pmccartney", "1")
          
          expect(@mock_employee_repo).to receive(:find_by).with("pmccartney").and_return(nil)

          expect(@mock_console_ui).to receive(:create_admin_message)

          admin_options_hash = {
            "1": "1. yes",
            "2": "2. no"
          }

          expect(@mock_console_ui).to receive(:display_menu_options).with(admin_options_hash)
          expect(@mock_employee_repo).to receive(:create).with("pmccartney", true)

          expect(@mock_employee_repo).to receive(:save)

          @employee_creation.execute(@repository)
        end
      end

      context "the user enters 'rstarr' who exists as a user" do
        it "prompts the user to create a different user name" do
          expect(@mock_console_ui).to receive(:get_user_input).and_return("rstarr", "pmccartney", "2")

          expect(@mock_employee_repo).to receive(:find_by).and_return(
            [
              Employee.new(1, "rstarr", false)
            ], nil)
          
          expect(@mock_console_ui).to receive(:username_exists_message).exactly(1).times


          @employee_creation.execute(@repository)
        end
      end

      context "the user enters an invalid admin option for the new username" do
        it "prompts the user to enter another admin option" do
          expect(@mock_console_ui).to receive(:get_user_input).and_return("pmccartney", "6", "2")

          expect(@mock_employee_repo).to receive(:find_by).and_return("pmccartney").and_return(nil)
          
          expect(@mock_console_ui).to receive(:valid_menu_option_message).exactly(1).times

          @employee_creation.execute(@repository)
        end
      end
    end
  end
end
