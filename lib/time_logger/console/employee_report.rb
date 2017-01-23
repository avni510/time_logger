module TimeLogger
  module Console
    class EmployeeReport

      def initialize(console_ui, employee_id)
        @console_ui = console_ui
        @employee_id = employee_id
      end

      def execute
        sorted_log_time_objects = retrieve_log_times

        return @console_ui.no_log_times_message unless sorted_log_time_objects

        retrieve_times_for_report(sorted_log_time_objects, @employee_id)

        @console_ui.format_employee_report(
          @sorted_log_times_array, 
          @clients_hours_hash, 
          @timecode_hours_hash
        )
      end

      private 

      def log_time_repo
        Repository.for(:log_time)
      end

      def retrieve_log_times
        log_time_repo.sorted_current_month_entries_by_employee_id(@employee_id)
      end

      def retrieve_times_for_report(sorted_log_time_objects, employee_id)
        @sorted_log_times_array = convert_objects_to_strings(sorted_log_time_objects)
        @clients_hours_hash = total_hours_per_client(employee_id)
        @timecode_hours_hash = total_hours_per_timecode(employee_id)
      end

      def convert_objects_to_strings(sorted_log_time_objects)
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

      def total_hours_per_client(employee_id)
        log_time_repo.employee_client_hours(employee_id)
      end

      def total_hours_per_timecode(employee_id)
        log_time_repo.employee_timecode_hours(employee_id)
      end
    end
  end
end
