module TimeLogger
  module Console
    class LogTimecode

      def initialize(console_ui, validation_menu)
        @console_ui = console_ui
        @validation_menu = validation_menu
      end

      def run(clients)
        timecode_options_hash = timecode_hash(clients)
        timecode_num_entered = @console_ui.timecode_log_time_message(timecode_options_hash)
        timecode_num_entered = valid_timecode_loop(timecode_options_hash, timecode_num_entered)

        timecode_selection_num_to_name(
            timecode_options_hash, 
            timecode_num_entered
          )
      end

      private

      def valid_timecode_loop(timecode_options_hash, timecode_num_entered)
        result = @validation_menu.validate(
                  timecode_options_hash, 
                  timecode_num_entered
        )
        until result.valid?
          @console_ui.puts_string(result.error_message)
          timecode_num_entered = @console_ui.get_user_input
          result = @validation_menu.validate(
                    timecode_options_hash, 
                    timecode_num_entered
          )
        end
        timecode_num_entered
      end

      def timecode_hash(clients)
        if clients.empty?
          generate_timecode_hash_without_billable
        else
          generate_timecode_hash_with_billable
        end
      end

      def generate_timecode_hash_with_billable
        { 
          "1": "1. Billable", 
          "2": "2. Non-Billable",
          "3": "3. PTO"
        }
      end

      def generate_timecode_hash_without_billable
        { 
          "1": "1. Non-Billable",
          "2": "2. PTO"
        }
      end

      def timecode_selection_num_to_name(timecode_hash, user_selection)
        timecode_type = timecode_hash[user_selection.to_sym]
        timecode_type[3..-1]
      end
    end
  end
end
