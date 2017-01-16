module TimeLogger
  module Console
    require "spec_helper"

    describe ClientCreation do 

      describe ".execute" do
        before(:each) do
          @mock_console_ui = double
          @validation = TimeLogger::Validation.new
          allow(@mock_console_ui).to receive(:new_client_name_message)
          allow(@mock_console_ui).to receive(:client_exists_message)
          @client_creation = ClientCreation.new(@mock_console_ui, @validation)
        end

        context "client name does not exist in memory" do
          it "prompts the user to enter a client name and saves it" do
            expect(@mock_console_ui).to receive(:new_client_name_message)

            expect(@mock_console_ui).to receive(:get_user_input).and_return("Google")

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:find_client).and_return(nil)

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:save_client)

            @client_creation.execute
          end
        end

        context "client name exists in memory" do
          it "prompts the user to enter a client name and saves it" do

            expect(@mock_console_ui).to receive(:get_user_input).and_return("Google", "Microsoft")

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:find_client).and_return(TimeLogger::Client.new(1, "Google"), nil)

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:save_client)
            @client_creation.execute
          end
        end

        context "the user enters a blank space" do
          it "prompts the user to enter a valid client name and saves it" do

            expect(@mock_console_ui).to receive(:get_user_input).and_return("", "Microsoft")

            expect(@mock_console_ui).to receive(:valid_client_name_message)

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:find_client).and_return(nil)

            expect_any_instance_of(TimeLogger::ClientRetrieval).to receive(:save_client)

            @client_creation.execute
          end
        end
      end
    end
  end
end
