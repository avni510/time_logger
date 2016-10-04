module TimeLogger
  class AdminReport
    def initialize(console_ui)
      @console_ui = console_ui
    end

    def execute
      timecode_hash = log_time_repo.company_timecode_hours

      return @console_ui.no_company_timecode_hours unless timecode_hash

      client_hash = log_time_repo.company_client_hours

      return @console_ui.no_client_hours unless client_hash

      @console_ui.format_admin_report(timecode_hash, client_hash)
    end

    private

    def log_time_repo
      Repository.for(:log_time)
    end
  end
end
