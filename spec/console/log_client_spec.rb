module TimeLogger
  module Console
    require "spec_helper"

    describe LogClient do
      let(:mock_console_ui) { double }
      let(:validation_menu) { TimeLogger::ValidationMenu.new }
      let(:log_client) { LogClient.new(mock_console_ui, validation_menu) }

      describe ".run" do 
        before(:each) do
          @clients = 
              [ 
                TimeLogger::Client.new(1, "Google"), 
                TimeLogger::Client.new(2, "Microsoft")
              ]

          @clients_hash = 
            {
              "1" => "1. Google",
              "2" => "2. Microsoft" 
            }

          allow(mock_console_ui).to receive(:display_menu_options).with(@clients_hash)
        end

        it "allows the user to enter the client they worked on" do
          expect(mock_console_ui).to receive(:display_menu_options).with(@clients_hash)

          expect(mock_console_ui).to receive(:get_user_input).and_return("2")

          expect(log_client.run(@clients)).to eq("Microsoft")
        end

        context "the user selects a client not on the list" do
          it "prompts them to enter a valid client" do
            expect(mock_console_ui).to receive(:get_user_input).and_return("5", "2")

            expect(mock_console_ui).to receive(:puts_string).with("Please enter a valid option")

            expect(log_client.run(@clients)).to eq("Microsoft")
          end
        end
      end
    end
  end
end
