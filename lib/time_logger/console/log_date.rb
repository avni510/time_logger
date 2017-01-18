module TimeLogger
  module Console
    class LogDate
      
      def initialize(console_ui, validation_date)
        @console_ui = console_ui
        @validation_date = validation_date
      end

      def run
        date_entered = @console_ui.date_log_time_message
        result = @validation_date.validate(date_entered)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          date_entered = @console_ui.get_user_input
          result = @validation_date.validate(date_entered)
        end
        date_entered
      end
    end
  end
end
