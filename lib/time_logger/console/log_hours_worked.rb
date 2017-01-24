module TimeLogger
  module Console
    class LogHoursWorked

      def initialize(console_ui, validation_log_time)
        @console_ui = console_ui
        @validation_log_time = validation_log_time
      end

      def run(employee_id, date_entered)
        hours_entered = @console_ui.hours_log_time_message
        result = validate_input(date_entered, hours_entered, employee_id)
        until result.valid?
          @console_ui.puts_string(result.error_message)
          return nil if result.code == :exceeds_24_hours
          hours_entered = @console_ui.get_user_input
          result = validate_input(date_entered, hours_entered, employee_id)
        end
        hours_entered
      end

      private 

      def validate_input(date_entered, hours_entered, employee_id)
        params = generate_validation_hash(date_entered, hours_entered, employee_id)
        @validation_log_time.validate(params)
      end

      def generate_validation_hash(date, hours_worked, employee_id)
        params = {
          :date => date, 
          :hours_worked => hours_worked, 
          :employee_id => employee_id
        }
      end
    end
  end
end
