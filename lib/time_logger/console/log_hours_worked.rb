module TimeLogger
  module Console
    class LogHoursWorked

      def initialize(console_ui, validation_hours_worked)
        @console_ui = console_ui
        @validation_hours_worked = validation_hours_worked
      end

      def run(previous_hours_worked)
        hours_entered = @console_ui.hours_log_time_message
        result = @validation_hours_worked.validate(previous_hours_worked, hours_entered)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          return nil if result.code == :exceeds_24_hours
          hours_entered = @console_ui.get_user_input
          result = @validation_hours_worked.validate(previous_hours_worked, hours_entered)
        end
        hours_entered
      end
    end
  end
end
