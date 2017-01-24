module TimeLogger
  module Console
    class LogDate
      
      def initialize(console_ui, validation_log_time)
        @console_ui = console_ui
        @validation_log_time = validation_log_time
      end

      def run
        date_entered = @console_ui.date_log_time_message
        params = {:date => date_entered}
        result = @validation_log_time.validate(params)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          date_entered = @console_ui.get_user_input
          params = {:date => date_entered}
          result = @validation_log_time.validate(params)
        end
        date_entered
      end
    end
  end
end
