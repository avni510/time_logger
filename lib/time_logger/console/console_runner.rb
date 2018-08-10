require 'pg'
module TimeLogger
  module Console
    class ConsoleRunner

      def initialize(console_ui)
        @console_ui = console_ui
      end

      def run
         connection = PG::Connection.open(:dbname => "time_logger") 
#        file_wrapper = InMemory::FileWrapper.new(File.expand_path("data/" + "time_logger_data.json"))
#        json_store = InMemory::JsonStore.new(file_wrapper) 
#        json_store.load   

#         params = {
#           :log_time_repo => InMemory::LogTimeRepo.new(json_store),
#           :employee_repo => InMemory::EmployeeRepo.new(json_store),
#           :client_repo => InMemory::ClientRepo.new(json_store)
#         }

         params = {
           :log_time_repo => SQL::LogTimeRepo.new(connection),
           :employee_repo => SQL::EmployeeRepo.new(connection),
           :client_repo => SQL::ClientRepo.new(connection)
         }

        RepositoryRegistry.setup(params)

        employee_setup = EmployeeSetup.new(@console_ui)
        employee_setup.run

        at_exit {
#          file_wrapper.write_data(json_store.data) 
          connection.close
        }
      end
    end
  end
end
