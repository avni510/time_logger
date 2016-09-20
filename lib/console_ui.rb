module TimeLogger
  class ConsoleUI

    def initialize(io_wrapper)
      @io_wrapper = io_wrapper
    end

    def username_display_message
      @io_wrapper.puts_string("Please enter your username")
    end

    def get_user_input
      @io_wrapper.get_action
    end

    def puts_space
      @io_wrapper.puts_string("")
    end

    def valid_username_message
      @io_wrapper.puts_string("Please enter a valid username")
    end

    def valid_menu_option_message
      @io_wrapper.puts_string("Please enter a valid menu option")
    end

    def menu_selection_message
      @io_wrapper.puts_string("Please select an option")
      puts_space
      @io_wrapper.puts_string("Enter the number next to the choice")
      puts_space
    end

    def display_menu_options(options_hash)
      options_hash.each do |selection_num, option|
        @io_wrapper.puts_string(option)
      end
      puts_space
    end

    def date_log_time_message
      general_log_time_message("Date (MM-DD-YYYY)")
    end

    def hours_log_time_message
      general_log_time_message("Hours Worked")
    end

    def general_log_time_message(display_string)
      @io_wrapper.puts_string(display_string)
      get_user_input
    end
    
    def timecode_log_time_message(timecode_hash)
      display_menu_options(timecode_hash)
      get_user_input
    end
  end
end
