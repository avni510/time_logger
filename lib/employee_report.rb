module TimeLogger
  class EmployeeReport
    
    def initialize(console_ui, employee_id)
      @console_ui = console_ui
      @employee_report_retrieval = EmployeeReportRetrieval.new(employee_id)
    end

    def execute
      sorted_log_time_objects = @employee_report_retrieval.log_times

      return @console_ui.no_log_times_message unless sorted_log_time_objects

      sorted_log_times_array = @employee_report_retrieval.
        convert_log_time_objects_to_strings(sorted_log_time_objects)

      clients_hours = @employee_report_retrieval.client_hours

      timecode_hours = @employee_report_retrieval.timecode_hours

      @console_ui.format_employee_report(
        sorted_log_times_array, 
        clients_hours, 
        timecode_hours
      )
    end
  end
end
