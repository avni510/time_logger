module TimeLogger
  require "spec_helper"

  describe ConsoleRunner do

    let(:mock_console_ui) { double }
    let(:mock_save_data) { double }
    let(:validation) { Validation.new }
    let(:file_name) {"/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"}
    let(:console_runner) { ConsoleRunner.new(mock_console_ui, mock_save_data, validation, file_name) }

    describe ".run" do
      it "prompts the user to enter their username" do
        expect(mock_console_ui).to receive(:username_display_message)

        expect(mock_console_ui).to receive(:get_user_input)

        allow_any_instance_of(MenuSelection).to receive(:menu_messages)

        console_runner.run
      end
    end
  end
end
