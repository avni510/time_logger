module TimeLogger
  class LoadDataToRepos

    def initialize(file_wrapper, save_json_data)
      @file_wrapper = file_wrapper
      @save_json_data = save_json_data
    end

    def run
      data_hash = @file_wrapper.read_data

      @employee_repo = EmployeeRepo.new(@save_json_data)

      @log_time_repo = LogTimeRepo.new(@save_json_data)

      load_repos(data_hash)
      
      setup_main_repository
    end

    private

    def load_repos(data_hash)
      data_hash["workers"].each do |worker|
        @employee_repo.create(worker["username"], worker["admin"])
        worker["log_time"].each do |log_time_entry|
          @log_time_repo.create(worker["id"], log_time_entry["date"], log_time_entry["hours_worked"], log_time_entry["timecode"], log_time_entry["client"])
        end
      end
    end

    def setup_main_repository
      repositories_hash = 
        { 
          "log_time": @log_time_repo,
          "employee": @employee_repo
        }

      Repository.new(repositories_hash)
    end
  end
end
