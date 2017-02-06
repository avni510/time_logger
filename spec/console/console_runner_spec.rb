require "spec_helper"
module TimeLogger
  module Console

    describe ConsoleRunner do
      let(:mock_console_ui) { double }
      let(:console_runner) { ConsoleRunner.new(mock_console_ui) }

      describe ".run" do
        it "calls the class that load the repos and calls the class to prompt the user for their username" do
          expect(RepositoryRegistry).to receive(:setup)
          expect_any_instance_of(EmployeeSetup).to receive(:run)
          console_runner.run
        end
      end
    end
  end
end
