module TimeLogger
  class Report
    
    def initialize(console_ui)
      @console_ui = console_ui
    end

    def execute(employee_id, repository)
      
      log_time_repo = repository.for(:log_time)
      unsorted_log_times = log_time_repo.find_by_employee_id(employee_id)

      sorted_log_times_objects = unsorted_log_times.sort_by{ |log_time_entry| log_time_entry.date }

      sorted_log_times_array = []

      sorted_log_times_objects.each do |log_time_entry|
        log_time_entry_array = 
          [
            log_time_entry.date,
            log_time_entry.hours_worked,
            log_time_entry.timecode,
            log_time_entry.client
          ]
        sorted_log_times_array << log_time_entry_array
      end
      
      clients_hours_hash = total_hours_per_client(sorted_log_times_objects)
      timecode_hours_hash = total_hours_per_timecode(sorted_log_times_objects)
      @console_ui.format_employee_self_report(sorted_log_times_array, clients_hours_hash, timecode_hours_hash)

    end

    def total_hours_per_client(log_time_objects)
      clients_hash = {}

      log_time_objects.each do |log_time|
        client = log_time.client
        if client 
          if clients_hash.include?(client)
            hours_worked = clients_hash[client].to_i + log_time.hours_worked.to_i
            hours_worked = hours_worked.to_s
            clients_hash[client] = hours_worked
          else
            clients_hash[client] = log_time.hours_worked
          end
        end
      end
      clients_hash
    end

    def total_hours_per_timecode(log_time_objects)
      timecode_hours_hash = {}

      log_time_objects.each do |log_time|
        timecode = log_time.timecode
        if timecode_hours_hash.include?(timecode)
          hours_per_timecode = timecode_hours_hash[timecode].to_i + log_time.hours_worked.to_i
          hours_per_timecode = hours_per_timecode.to_s
          timecode_hours_hash[timecode] = hours_per_timecode
        else
          timecode_hours_hash[timecode] = log_time.hours_worked
        end
      end
      timecode_hours_hash
    end
  end
end
