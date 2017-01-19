module TimeLogger
  module Console
    class LogTime

      BILLABLE_TIMECODE = "Billable"

      def initialize(params)
        @log_date = params[:log_date]
        @log_hours_worked = params[:log_hours_worked]
        @log_timecode = params[:log_timecode]
        @log_client = params[:log_client]
        @employee_id = params[:employee_id]
        @log_time_retrieval = TimeLogger::LogTimeRetrieval.new
      end

      def execute
        date_entered = @log_date.run
        hours_entered = @log_hours_worked.run(@employee_id, date_entered)
        return execute unless hours_entered
        clients = @log_time_retrieval.all_clients
        timecode_entered = @log_timecode.run(clients)
        client_entered = select_client(timecode_entered, clients)
        @log_time_retrieval.save_log_time_entry(
          @employee_id, 
          date_entered, 
          hours_entered, 
          timecode_entered, 
          client_entered
        )
      end

      private

      def select_client(timecode, clients)
        @log_client.run(clients) if timecode == BILLABLE_TIMECODE 
      end
    end
  end
end
