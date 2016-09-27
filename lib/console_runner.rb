module TimeLogger
  class ConsoleRunner

    def initialize(console_ui, save_data, validation, file_name, file_wrapper)
      @console_ui = console_ui
      @save_data = save_data
      @validation = validation
      @file_name = file_name
      @file_wrapper = file_wrapper
    end

    def run
      log_time_repo = populate_data

      repository = set_up_repos(log_time_repo)

      @console_ui.username_display_message
      username = @console_ui.get_user_input
      # Validation that the employee entered exists 

      @worker = Employee.new(username, @save_data)

      menu_selection = MenuSelection.new(username, @file_name, @console_ui, @validation, repository)

      menu_selection.menu_messages
    end

    def set_up_repos(log_time_repo)
      repos_hash = 
        {
          "log_time": log_time_repo
        }
      Repository.new(repos_hash)
    end

    def populate_data
      data_hash = @file_wrapper.read_data(@file_name)

      log_time_repo = LogTimeRepo.new(@save_data)

      data_hash["workers"][0]["log_time"].each do |log_time_entry|
        puts log_time_entry

        log_time_repo.create(data_hash["workers"][0]["id"], log_time_entry["date"], log_time_entry["hours_worked"], log_time_entry["timecode"], log_time_entry["client"])
      end

      log_time_repo
    end
  end
end
