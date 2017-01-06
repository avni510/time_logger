module TimeLogger
  class ReportRetrieval

    def initialize(employee_id=nil)
      @employee_id = employee_id
    end

    def log_times
      log_time_repo.sorted_current_month_entries_by_employee_id(@employee_id)
    end

    def convert_log_time_objects_to_strings(sorted_log_time_objects)
      sorted_log_times_array = []

      sorted_log_time_objects.each do |log_time_entry|
        log_time_entry_array = 
          [
            "#{log_time_entry.date.month}-#{log_time_entry.date.day}-#{log_time_entry.date.year}",
            log_time_entry.hours_worked.to_s,
            log_time_entry.timecode,
            log_time_entry.client
          ]

        sorted_log_times_array << log_time_entry_array
      end
      sorted_log_times_array
    end

    def client_hours
      log_time_repo.employee_client_hours(@employee_id)
    end

    def timecode_hours
      log_time_repo.employee_timecode_hours(@employee_id)
    end

    def company_wide_timecode_hours
      log_time_repo.company_timecode_hours
    end

    def company_wide_client_hours
      log_time_repo.company_client_hours
    end

    private

    def log_time_repo
      Repository.for(:log_time)
    end
  end
end
