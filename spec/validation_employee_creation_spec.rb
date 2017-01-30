require "spec_helper"
module TimeLogger

  describe ValidationEmployeeCreation do
    before(:each) do
      @mock_employee_repo = double
      @employee_1 = setup_employee
      @validation_employee_creation = ValidationEmployeeCreation.new(@mock_employee_repo)
    end

    def setup_employee
      Employee.new(1, "rstarr", false)
    end

    describe ".validate" do
      context "the user enters a new user that does not exist" do
        it "returns an instance of the Result object with the appropiate errors" do
          expect(@mock_employee_repo).to receive(:find_by_username).and_return(nil)
          result = @validation_employee_creation.validate("gharrison")
          expect(result.error_message).to eq(nil)
        end
      end

      context "the user enters 'rstarr' who exists as a user" do
        it "returns an instance of the Result object with the appropiate errors" do
          invalid_username_message = "This user already exists, please enter a different one" 
          expect(@mock_employee_repo).to receive(:find_by_username).and_return(@employee_1)
          result = @validation_employee_creation.validate("rstarr")
          expect(result.error_message).to eq(invalid_username_message)
        end
      end

      context "the user enters a blank space for the username" do
        it "returns an instance of the result object with the proper errors" do
          blank_space_message = "Your input cannot be blank"
          [ 
            ["", blank_space_message],
            ["   ", blank_space_message],
            ["gharrison", nil]
          ].each do |user_input, value|
            allow(@mock_employee_repo).to receive(:find_by_username).and_return(nil)
            result = @validation_employee_creation.validate(user_input)
            expect(result.error_message).to eq(value)
          end
        end
      end
    end
  end
end
