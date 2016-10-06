module TimeLogger
  require "spec_helper"

  describe ClientCreation do 

    describe ".execute" do
      before(:each) do
        @mock_console_ui = double
        @validation = Validation.new
        @client_creation = ClientCreation.new(@mock_console_ui, @validation)

        @mock_client_repo = double
        allow(Repository).to receive(:for).and_return(@mock_client_repo)

        allow(@mock_console_ui).to receive(:new_client_name_message)
        allow(@mock_console_ui).to receive(:client_exists_message)

        allow(@mock_client_repo).to receive(:create)
        allow(@mock_client_repo).to receive(:save)
      end

      context "client name does not exist in memory" do
        it "prompts the user to enter a client name and saves it" do
          expect(@mock_console_ui).to receive(:new_client_name_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("Google")

          allow(@mock_client_repo).to receive(:find_by_name).and_return(nil)

          expect(@mock_client_repo).to receive(:create).with("Google")

          expect(@mock_client_repo).to receive(:save)

          @client_creation.execute
        end
      end

      context "client name exists in memory" do
        it "prompts the user to enter a client name and saves it" do

          expect(@mock_console_ui).to receive(:get_user_input).and_return("Google", "Microsoft")

          expect(@mock_client_repo).to receive(:find_by_name).and_return( Client.new(1, "Google"), nil)

          @client_creation.execute
        end
      end

      context "the user enters a blank space" do
        it "prompts the user to enter a valid client name and saves it" do

          expect(@mock_console_ui).to receive(:get_user_input).and_return("", "Microsoft")

          expect(@mock_console_ui).to receive(:valid_client_name_message)

          expect(@mock_client_repo).to receive(:find_by_name).and_return(nil)

          @client_creation.execute
        end
      end
    end
  end
end
