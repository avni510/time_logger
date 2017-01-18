module TimeLogger
  module Console
    require "spec_helper"

    describe ClientCreation do 

      describe ".execute" do
        before(:each) do
          @mock_console_ui = double
          @mock_client_repo = double
          @validation_client_creation = TimeLogger::ValidationClientCreation.new(@mock_client_repo)
          allow(@mock_console_ui).to receive(:new_client_name_message)
          @client_creation = ClientCreation.new(@mock_console_ui, @validation_client_creation)
        end

        context "client name does not exist in memory" do
          it "prompts the user to enter a client name and saves it" do
            expect(@mock_console_ui).to receive(:new_client_name_message)

            expect(@mock_console_ui).to receive(:get_user_input).and_return("Google")
            
            expect(@mock_client_repo).to receive(:find_by_name).with("Google").and_return(nil)

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:save_client)

            @client_creation.execute
          end
        end

        context "client name exists in memory" do
          it "prompts the user to enter a client name and saves it" do

            expect(@mock_console_ui).to receive(:get_user_input).and_return("Google", "Microsoft")

            expect(@mock_client_repo).to receive(:find_by_name).and_return(TimeLogger::Client.new(1, "Google"), nil)

            expect(@mock_console_ui).to receive(:puts_string).with("This client already exists, please enter a different one")

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:save_client)

            @client_creation.execute
          end
        end

        context "the user enters a blank space" do
          it "prompts the user to enter a valid client name and saves it" do

            expect(@mock_console_ui).to receive(:get_user_input).and_return("", "Microsoft")

            expect(@mock_console_ui).to receive(:puts_string).with("Your input cannot be blank")

            expect(@mock_client_repo).to receive(:find_by_name).and_return(nil)

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:save_client)

            @client_creation.execute
          end
        end
      end
    end
  end
end
