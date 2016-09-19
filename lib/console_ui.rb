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

    def display_menu_options(options_hash)
      options_hash.each do |selection_num, option|
        @io_wrapper.puts_string(option)
      end
      puts_space
    end
  end
end
