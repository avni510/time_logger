module TimeLogger
  module Console
    class ConsoleRunner

      def initialize(file_wrapper, save_json_data, console_ui)
        @file_wrapper = file_wrapper
        @save_json_data = save_json_data
        @console_ui = console_ui
      end

      def run
        load_data = TimeLogger::LoadDataToRepos.new(@file_wrapper, @save_json_data)
        load_data.run

        employee_setup = EmployeeSetup.new(@console_ui)
        employee_setup.run
      end
    end
  end
end
