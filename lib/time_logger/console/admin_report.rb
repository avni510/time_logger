module TimeLogger
  module Console
    class AdminReport
      def initialize(console_ui)
        @console_ui = console_ui
        @report_retrieval = TimeLogger::ReportRetrieval.new
      end

      def execute
        company_timecodes = @report_retrieval.company_wide_timecode_hours
        return @console_ui.no_company_log_entries_message unless company_timecodes
        company_clients = @report_retrieval.company_wide_client_hours
        @console_ui.format_admin_report(company_timecodes, company_clients)
      end
    end
  end
end
