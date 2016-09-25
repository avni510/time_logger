module TimeLogger
  class Report
    
    def initialize(retrieve_data, console_ui)
      @retrieve_data = retrieve_data
      @console_ui = console_ui
    end

    def self_summary(username)
      log_times_array = @retrieve_data.user_log_times(username)
      sorted_log_times = log_times_array.sort_by{ |log_time| log_time["date"] }
      clients_hours_hash = total_hours_per_client(sorted_log_times)
      timecode_hours_hash = total_hours_per_timecode(sorted_log_times)
      @console_ui.format_employee_self_report(sorted_log_times, clients_hours_hash, timecode_hours_hash)

    end

    def total_hours_per_client(sorted_log_times)
      clients_hash = {}

      sorted_log_times.each do |log_time|
        client = log_time["client"]
        if client 
          if clients_hash.include?(client)
            hours_worked = clients_hash[client].to_i + log_time["hours_worked"].to_i
            hours_worked = hours_worked.to_s
            clients_hash[client] = hours_worked
          else
            clients_hash[client] = log_time["hours_worked"]
          end
        end
      end
      clients_hash
    end

    def total_hours_per_timecode(sorted_log_times)
      timecode_hours_hash = {}

      sorted_log_times.each do |log_time|
        timecode = log_time["timecode"]
        if timecode_hours_hash.include?(timecode)
          hours_per_timecode = timecode_hours_hash[timecode].to_i + log_time["hours_worked"].to_i
          hours_per_timecode = hours_per_timecode.to_s
          timecode_hours_hash[timecode] = hours_per_timecode
        else
          timecode_hours_hash[timecode] = log_time["hours_worked"]
        end
      end
      timecode_hours_hash
    end
  end
end
