module TimeLogger
  class LogTimeRetrieval
    
    def employee_hours_worked_for_date(employee_id, date_entered)
      log_time_repo.find_total_hours_worked_for_date(
        employee_id,
        date_entered
      )
    end

    def all_clients
      client_repo.all
    end

    def save_log_time_entry(employee_id, date, hours, timecode, client)
      log_entry_hash = generate_log_times_hash(
        employee_id, 
        date, 
        hours, 
        timecode,
        client
      )

      log_time_repo.create(log_entry_hash)

      log_time_repo.save
    end

    private

    def log_time_repo
      Repository.for(:log_time)
    end

    def client_repo
      Repository.for(:client)
    end
    
    def generate_log_times_hash(employee_id, date, hours_worked, timecode, client)
      params = 
        { 
          "employee_id": employee_id,
          "date": Date.strptime(date, '%m-%d-%Y').to_s,
          "hours_worked": hours_worked,
          "timecode": timecode, 
          "client": client
        }
    end
  end
end
