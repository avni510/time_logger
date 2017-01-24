module TimeLogger
  require "spec_helper"
  
  describe ValidationClientCreation do
    before(:each) do
      @mock_client_repo = double
      @client_1 = setup_client
      @validation_client_creation = ValidationClientCreation.new(@mock_client_repo)
    end

    def setup_client
      TimeLogger::Client.new(1, "Google")
    end

    describe ".validate" do
      context "the user enters a new client that does not exist" do
        it "returns an instance of the Result object with the appropiate errors" do
          expect(@mock_client_repo).to receive(:find_by_name).and_return(nil)
          result = @validation_client_creation.validate("Google")
          expect(result.error_message).to eq(nil)
        end
      end


      context "the user enters the client 'Google' who already exists" do
        it "returns an instance of the Result object with the appropiate errors" do
          invalid_client_message = "This client already exists, please enter a different one" 
          expect(@mock_client_repo).to receive(:find_by_name).and_return(@client_1)
          result = @validation_client_creation.validate("Microsoft")
          expect(result.error_message).to eq(invalid_client_message)
        end
      end

      context "the user enters a blank space for the username" do
        it "returns an instance of the result object with the proper errors" do
          blank_space_message = "Your input cannot be blank"
          [ 
            ["", blank_space_message],
            ["   ", blank_space_message],
            ["Microsoft", nil]
          ].each do |user_input, value|
            allow(@mock_client_repo).to receive(:find_by_name).and_return(nil)
            result = @validation_client_creation.validate(user_input)
            expect(result.error_message).to eq(value)
          end
        end
      end
    end
  end
end
