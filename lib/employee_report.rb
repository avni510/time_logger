module TimeLogger
  class EmployeeReport
    
    def initialize(console_ui)
      @console_ui = console_ui
    end

    def execute(employee_id, repository)
      @repository = repository

      unsorted_log_time_objects = retrieve_log_times(employee_id)

      return @console_ui.no_log_times_message unless unsorted_log_time_objects

      @sorted_log_time_objects = relevant_log_times(unsorted_log_time_objects)
      
      calculate_report_values

      @console_ui.format_employee_report(
        @sorted_log_times_array, 
        @clients_hours_hash, 
        @timecode_hours_hash
      )
    end
    
    private 

    def log_time_repo
      @repository.for(:log_time)
    end

    def retrieve_log_times(employee_id) 
      log_time_repo.find_by(employee_id)
    end

    def relevant_log_times(unsorted_log_time_objects)
      filtered_log_times = filter_for_current_month(unsorted_log_time_objects)
      sort_log_times(filtered_log_times)
    end

    def filter_for_current_month(log_time_objects)
      today = Date.today
      log_time_objects = log_time_objects.reject { 
        |log_time| log_time.date[0..1].to_i < today.month || 
        log_time.date[-4..-1].to_i < today.year
      }
    end

    def calculate_report_values
      convert_objects_to_strings
      total_hours_per_client
      total_hours_per_timecode
    end

    def sort_log_times(unsorted_log_time_objects)
      unsorted_log_time_objects.sort_by{ |log_time_entry| log_time_entry.date }
    end

    def convert_objects_to_strings
      @sorted_log_times_array = []

      @sorted_log_time_objects.each do |log_time_entry|
        log_time_entry_array = 
          [
            log_time_entry.date,
            log_time_entry.hours_worked,
            log_time_entry.timecode,
            log_time_entry.client
          ]

        @sorted_log_times_array << log_time_entry_array
      end
    end

    def total_hours_per_client
      @clients_hours_hash = {}

#      log_entries = @sorted_log_time_objects.reject{ |log_time| log_time.client.nil? }

      @sorted_log_time_objects.each do |log_time|
        client = log_time.client
        if client 
          if @clients_hours_hash.include?(client)
            hours_worked = @clients_hours_hash[client].to_i + log_time.hours_worked.to_i
            hours_worked = hours_worked.to_s
            @clients_hours_hash[client] = hours_worked
          else
            @clients_hours_hash[client] = log_time.hours_worked
          end
        end
      end
      @clients_hours_hash
    end

    def total_hours_per_timecode
      @timecode_hours_hash = {}

      @sorted_log_time_objects.each do |log_time|
        timecode = log_time.timecode
        if @timecode_hours_hash.include?(timecode)
          hours_per_timecode = @timecode_hours_hash[timecode].to_i + log_time.hours_worked.to_i
          hours_per_timecode = hours_per_timecode.to_s
          @timecode_hours_hash[timecode] = hours_per_timecode
        else
          @timecode_hours_hash[timecode] = log_time.hours_worked
        end
      end
      @timecode_hours_hash
    end
  end
end
