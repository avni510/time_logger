module TimeLogger
  module Console
    class WorkerSetup

      def initialize(console_ui)
        @console_ui = console_ui
      end

      def run
        @console_ui.username_display_message
        username = @console_ui.get_user_input
        employee = employee_repo.find_by_username(username)
        employee = valid_username_loop(employee)
        menu_selection = MenuSelection.new(employee, @console_ui)
        menu_selection.run
      end

      private

      def valid_username_loop(employee)
        until employee
          @console_ui.username_does_not_exist_message
          username = @console_ui.get_user_input
          employee = employee_repo.find_by_username(username)
        end
        employee
      end

      def employee_repo
        Repository.for(:employee)
      end
    end
  end
end
