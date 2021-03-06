require "spec_helper"
module TimeLogger
  module Console

    describe LogTimecode do
      let(:mock_console_ui) { double }
      let(:validation_menu) { TimeLogger::ValidationMenu.new }
      let(:log_timecode) { LogTimecode.new(mock_console_ui, validation_menu) }

      describe ".run" do 
        before(:each) do
          @clients = 
              [ 
                TimeLogger::Client.new(1, "Google"), 
                TimeLogger::Client.new(2, "Microsoft")
              ]

          @timecode_hash_with_clients = 
            { 
              "1": "1. Billable", 
              "2": "2. Non-Billable",
              "3": "3. PTO"
            }

          @timecode_hash_without_clients = 
            { 
              "1": "1. Non-Billable",
              "2": "2. PTO"
            }
        end

        it "allows the user to enter the date they worked" do
          expect(mock_console_ui).to receive(:timecode_log_time_message).
            with(@timecode_hash_with_clients).
            and_return("2")

          expect(log_timecode.run(@clients)).to eq("Non-Billable")
        end

        context "an invalid timecode is entered that is not displayed in the menu" do
          it "prompts the user to enter a menu option" do
            expect(mock_console_ui).to receive(:timecode_log_time_message).
              with(@timecode_hash_with_clients).
              and_return("4")

            expect(mock_console_ui).to receive(:puts_string).with("Please enter a valid option")

            expect(mock_console_ui).to receive(:get_user_input).and_return("3")

            expect(log_timecode.run(@clients)).to eq("PTO")
          end
        end

        context "there are no clients" do
          it "does not display the option to select 'Billable' as a timecode" do
            @clients = []
                
            expect(mock_console_ui).to receive(:timecode_log_time_message).
              with(@timecode_hash_without_clients).
              and_return("1")

            expect(log_timecode.run(@clients)).to eq("Non-Billable")
          end
        end
      end
    end
  end
end
