module TimeLogger
  require "spec_helper"

  describe LogClient do
    let(:mock_console_ui) { double }
    let(:validation) { Validation.new }
    let(:log_client) { LogClient.new(mock_console_ui, validation) }

    describe ".run" do 
      before(:each) do
        @clients = 
            [ 
              Client.new(1, "Google"), 
              Client.new(2, "Microsoft")
            ]

        @clients_hash = 
          {
            1 => "1. Google",
            2 => "2. Microsoft" 
          }

        allow(mock_console_ui).to receive(:display_menu_options).with(@clients_hash)
      end

      it "the user to enter the client they worked on" do
        expect(mock_console_ui).to receive(:display_menu_options).with(@clients_hash)

        expect(mock_console_ui).to receive(:get_user_input).and_return("2")

        log_client.run(@clients)
      end

      context "the user selects a client not on the list" do
        it "prompts them to enter a valid client" do
          expect(mock_console_ui).to receive(:get_user_input).and_return("5", "2")

          expect(mock_console_ui).to receive(:invalid_client_selection_message)
            
          log_client.run(@clients)
        end
      end

      it "return the client name" do
        expect(mock_console_ui).to receive(:get_user_input).and_return("2")

        result = log_client.run(@clients)
        expect(result).to eq("Microsoft")
      end
    end
  end
end
