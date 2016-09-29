module TimeLogger
  require "spec_helper"

  describe ConsoleRunner do
    let(:mock_file_wrapper) { double }
    let(:mock_save_json_data) { double }
    let(:mock_console_ui) { double }
    let(:console_runner) { ConsoleRunner.new(mock_file_wrapper, mock_save_json_data, mock_console_ui) }

    def setup_repositories
      repositories_hash = 
        {
          "log_time": double,
          "employee": double
        }
      Repository.new(repositories_hash)
    end

    describe ".run" do
      it "calls the class that load the repos and calls the class to prompt the user for their username" do
        repository = setup_repositories

        expect_any_instance_of(LoadDataToRepos).to receive(:run).and_return(repository)

        expect_any_instance_of(WorkerSetup).to receive(:run)

        console_runner.run
      end
    end
  end
end
