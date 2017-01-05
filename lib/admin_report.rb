module TimeLogger
  class AdminReport
    def initialize(console_ui)
      @console_ui = console_ui
      @admin_report_retrieval = AdminReportRetrieval.new
    end

    def execute
      company_timecodes = @admin_report_retrieval.timecode_hours
      return @console_ui.no_company_log_entries_message unless company_timecodes
      company_clients = @admin_report_retrieval.client_hours
      @console_ui.format_admin_report(company_timecodes, company_clients)
    end
  end
end
