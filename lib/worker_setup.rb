module TimeLogger
  class WorkerSetup

    def initialize(console_ui)
      @console_ui = console_ui
    end

    def run
      @console_ui.username_display_message

      username = @console_ui.get_user_input
      
      @worker = return_worker(username)
      
      valid_username_loop(employee_repo)

      menu_selection = MenuSelection.new(@worker, @console_ui)

      menu_selection.run
    end

    private

    def return_worker(username)
      employee_repo.find_by_username(username)
    end

    def employee_repo
      Repository.for("employee")
    end

    def valid_username_loop(employee_repo)
      until @worker
        @console_ui.username_does_not_exist_message
        username = @console_ui.get_user_input
        @worker = employee_repo.find_by_username(username)
      end
    end
  end
end
