module TimeLogger
  class LogTime

    BILLABLE_TIMECODE = "Billable"

    def initialize(log_date, log_hours_worked, log_timecode, log_client)
      @log_date = log_date
      @log_hours_worked = log_hours_worked
      @log_timecode = log_timecode
      @log_client = log_client
    end

    def execute(employee_id)
      date_entered = @log_date.run

      previous_hours_worked = log_time_repo.
        find_total_hours_worked_for_date(
            employee_id, 
            date_entered
        )

      hours_entered = @log_hours_worked.run(previous_hours_worked)

      execute(employee_id) unless hours_entered

      timecode_entered = @log_timecode.run(client_repo.all)

      client_entered = select_client(timecode_entered)

      save_log_time_entry(
        employee_id,
        date_entered,
        hours_entered,
        timecode_entered,
        client_entered
      )
    end

    private

    def log_time_repo
      Repository.for(:log_time)
    end

    def client_repo
      Repository.for(:client)
    end

    def select_client(timecode)
      if timecode == BILLABLE_TIMECODE 
        @log_client.run(client_repo.all)
      end
    end

    def save_log_time_entry(employee_id, date_entered, hours_entered, timecode_entered, client_entered)
      log_entry_hash = generate_log_times_hash(
        employee_id, 
        date_entered, 
        hours_entered, 
        timecode_entered,
        client_entered
      )

      log_time_repo.create(log_entry_hash)

      log_time_repo.save
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
