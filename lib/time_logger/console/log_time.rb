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
      end

      def execute
        date_entered = @log_date.run
        hours_entered = @log_hours_worked.run(@employee_id, date_entered)
        return execute unless hours_entered
        clients = client_repo.all
        timecode_entered = @log_timecode.run(clients)
        client_entered = select_client(timecode_entered, clients)
        create_log_entry(
          date_entered,
          hours_entered,
          timecode_entered, 
          client_entered
        )
      end

      private
      
      def client_repo
        Repository.for(:client)
      end

      def log_time_repo
        Repository.for(:log_time)
      end

      def select_client(timecode, clients)
        @log_client.run(clients) if timecode == BILLABLE_TIMECODE 
      end

      def generate_log_time_hash(employee_id, date, hours_worked, timecode, client)
        params = 
          { 
            "employee_id": employee_id,
            "date": Date.strptime(date, '%m-%d-%Y').to_s,
            "hours_worked": hours_worked,
            "timecode": timecode, 
            "client": client
          }
      end

      def create_log_entry(date, hours_worked, timecode, client)
        log_time_hash = generate_log_time_hash(
          @employee_id,
          date,
          hours_worked,
          timecode,
          client
        )
        log_time_repo.create(log_time_hash)
      end
    end
  end
end
