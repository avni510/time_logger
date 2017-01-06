module TimeLogger
  class EmployeeReport
    
    def initialize(console_ui, employee_id)
      @console_ui = console_ui
      @report_retrieval = ReportRetrieval.new(employee_id)
    end

    def execute
      sorted_log_time_objects = @report_retrieval.log_times
      
      return @console_ui.no_log_times_message unless sorted_log_time_objects

      sorted_log_times_array = @report_retrieval.
        convert_log_time_objects_to_strings(sorted_log_time_objects)

      clients_hours = @report_retrieval.client_hours

      timecode_hours = @report_retrieval.timecode_hours

      @console_ui.format_employee_report(
        sorted_log_times_array, 
        clients_hours, 
        timecode_hours
      )
    end
  end
end
