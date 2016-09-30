module TimeLogger
  class ConsoleRunner
    
    def initialize(file_wrapper, save_json_data, console_ui)
      @file_wrapper = file_wrapper
      @save_json_data = save_json_data
      @console_ui = console_ui
    end

    def run
      load_data = LoadDataToRepos.new(@file_wrapper, @save_json_data)
      repository = load_data.run

      worker_setup = WorkerSetup.new(@console_ui, repository)
      worker_setup.run
    end
  end
end
