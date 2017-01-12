module TimeLoggerConsole
  class LogTimecode

    def initialize(console_ui, validation)
      @console_ui = console_ui
      @validation = validation
    end

    def run(clients)
      timecode_options_hash = timecode_hash(clients)

      timecode_num_entered = @console_ui.timecode_log_time_message(timecode_options_hash)

      timecode_num_entered = valid_timecode_loop(
          timecode_options_hash, 
          timecode_num_entered
        )

      timecode_selection_num_to_name(
          timecode_options_hash, 
          timecode_num_entered
        )
    end

    private

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

    def valid_timecode_loop(timecode_hash, timecode_entered)
      until @validation.menu_selection_valid?(timecode_hash, timecode_entered)
        @console_ui.valid_menu_option_message
        timecode_entered = @console_ui.get_user_input
      end
      timecode_entered
    end

    def timecode_selection_num_to_name(timecode_hash, user_selection)
      timecode_type = timecode_hash[user_selection.to_sym]
      timecode_type[3..-1]
    end
  end
end
