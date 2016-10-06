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

      @client_repo = ClientRepo.new(@save_json_data)

      load_employee_and_log_times_repos(data_hash)

      load_client_repo(data_hash)
      
      setup_main_repository
    end

    private

    def load_employee_and_log_times_repos(data_hash)
      data_hash["workers"].each do |worker|
        @employee_repo.create(
          worker["username"], 
          worker["admin"]
        )
        worker["log_time"].each do |log_time_entry|
          params = generate_log_time_hash(
            worker["id"], 
            log_time_entry["date"], 
            log_time_entry["hours_worked"], 
            log_time_entry["timecode"], 
            log_time_entry["client"]
          )
          @log_time_repo.create(params)
        end
      end
    end

    def load_client_repo(data_hash)
      data_hash["clients"].each do |client|
        @client_repo.create(client["name"])
      end
    end

    def generate_log_time_hash(employee_id, date, hours_worked, timecode, client)
      { 
        "employee_id": employee_id,
        "date": date,
        "hours_worked": hours_worked,
        "timecode": timecode, 
        "client": client
      }
    end

    def setup_main_repository
      Repository.repositories
      Repository.register("log_time", @log_time_repo)
      Repository.register("employee", @employee_repo)
      Repository.register("client", @client_repo)
    end
  end
end
