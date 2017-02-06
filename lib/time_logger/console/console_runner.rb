module TimeLogger
  module Console
    class ConsoleRunner

      def initialize(console_ui)
        @console_ui = console_ui
      end

      def run
        file_wrapper = InMemory::FileWrapper.new(File.expand_path("data/" + "time_logger_data.json"))
        json_store = InMemory::JsonStore.new(file_wrapper) 
        json_store.load   

        params = {
          :log_time_repo => InMemory::LogTimeRepo.new(json_store),
          :employee_repo => InMemory::EmployeeRepo.new(json_store),
          :client_repo => InMemory::ClientRepo.new(json_store)
        }
        RepositoryRegistry.setup(params)

        employee_setup = EmployeeSetup.new(@console_ui)
        employee_setup.run

        at_exit {
          file_wrapper.write_data(json_store.data) 
        }
      end
    end
  end
end
