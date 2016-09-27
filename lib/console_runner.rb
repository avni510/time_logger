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
      employee_repo = populate_employees
      log_time_repo = populate_log_time

      @repository = setup_repos(log_time_repo, employee_repo)


      @console_ui.username_display_message
      username = @console_ui.get_user_input
      # Validation that the employee entered exists 

      menu_selection = MenuSelection.new(username, @file_name, @console_ui, @validation, @repository)

      menu_selection.menu_messages
    end


    def setup_repos(log_time_repo, employee_repo)
      repositories_hash = 
        { 
          "log_time": log_time_repo,
          "employee": employee_repo
        }

      Repository.new(repositories_hash)
    end


    def populate_employees
      data_hash = @file_wrapper.read_data(@file_name)

      employee_repo = EmployeeRepo.new(@save_data)

      data_hash["workers"].each do |worker|
        employee_repo.create(worker["username"], worker["admin"])
      end

      employee_repo
    end

    def populate_log_time
      data_hash = @file_wrapper.read_data(@file_name)

      log_time_repo = LogTimeRepo.new(@save_data)

      data_hash["workers"].each do |worker|
        worker["log_time"].each do |log_time_entry|
          log_time_repo.create(worker["id"], log_time_entry["date"], log_time_entry["hours_worked"], log_time_entry["timecode"], log_time_entry["client"])
        end
      end

      log_time_repo
    end
  end
end
