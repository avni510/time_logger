module TimeLogger
  class ConsoleUI

    def initialize(io_wrapper)
      @io_wrapper = io_wrapper
    end

    def username_display_message
      @io_wrapper.puts_string("Please enter your username")
    end

    def username_does_not_exist_message
      @io_wrapper.puts_string("This username does not exist")
    end

    def get_user_input
      @io_wrapper.get_action
    end

    def puts_space
      @io_wrapper.puts_string("")
    end

    def valid_hours_message
      @io_wrapper.puts_string("You have exceeded 24 hours for this day.")
    end

    def valid_username_message
      @io_wrapper.puts_string("Please enter a valid username")
    end

    def valid_menu_option_message
      @io_wrapper.puts_string("Please enter a valid menu option")
    end
    
    def valid_date_message
      @io_wrapper.puts_string("Please enter a valid date")
    end

    def future_date_valid_message
      @io_wrapper.puts_string("Please enter a date in the past")
    end

    def enter_digit_message
      @io_wrapper.puts_string("Please enter a number")
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

    def format_employee_self_report(log_times_sorted, client_hash, timecode_hash)
      @io_wrapper.puts_string("This is a report for the current month")

      puts_space

      @io_wrapper.puts_string("Date" + "            "  + "Hours Worked" + "            " + "Timecode" + "            " + "Client")
      log_times_sorted.each do |log_time|

        items_to_print = log_time[0] + "            " + log_time[1] + "            " + log_time[2] 
        if log_time[3]
          items_to_print = items_to_print + "            " + log_time[3]
        end

        @io_wrapper.puts_string(items_to_print)
      end

      puts_space

      format_client_hours_worked(client_hash)

      puts_space

      format_timecode_hours_worked(timecode_hash)
      puts_space
    end

    def format_client_hours_worked(clients_hash)
      clients_hash.each do |client, hours_worked|
          @io_wrapper.puts_string("Total hours worked for #{client}" + " : " + "#{hours_worked}")
      end
    end

    def format_timecode_hours_worked(timecode_hash)
      timecode_hash.each do |timecode, hours_worked|
          @io_wrapper.puts_string("Total #{timecode} hours worked" + " : " + "#{hours_worked}")
      end
    end
  end
end
