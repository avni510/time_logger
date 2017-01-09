module TimeLogger
  class WorkerSetup

    def initialize(console_ui)
      @console_ui = console_ui
      @worker_retrieval = WorkerRetrieval.new
    end

    def run
      @console_ui.username_display_message

      username = @console_ui.get_user_input
      
      worker = @worker_retrieval.employee(username)
     
      worker = valid_username_loop(worker)

      menu_selection = MenuSelection.new(worker, @console_ui)

      menu_selection.run
    end

    private

    def valid_username_loop(worker)
      until worker
        @console_ui.username_does_not_exist_message
        username = @console_ui.get_user_input
        worker = @worker_retrieval.employee(username)
      end
      worker
    end
  end
end
