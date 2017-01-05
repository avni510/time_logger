module TimeLogger
  class AdminReportRetrieval 

    def timecode_hours
      log_time_repo.company_timecode_hours
    end

    def client_hours
      log_time_repo.company_client_hours
    end

    private

    def log_time_repo
      Repository.for(:log_time)
    end
  end
end
