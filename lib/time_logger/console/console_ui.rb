module TimeLogger
  module Console
    class ConsoleUI

      def initialize(io_wrapper)
        @io_wrapper = io_wrapper
      end

      def puts_string(string)
        @io_wrapper.puts_string(string)
      end

      def puts_space
        @io_wrapper.puts_string("")
      end

      def get_user_input
        @io_wrapper.get_action
      end

      def username_display_message
        general_message_format("Please enter your username")
      end

      def username_does_not_exist_message
        general_message_format("This username does not exist")
      end

      def enter_new_username_message
        general_message_format("Please enter the username you would like to create")
      end

      def create_admin_message
        general_message_format("Would you like the user to be an admin?")
      end

      def no_company_log_entries_message
        general_message_format("The company doesn't have any log entries for the current month")
      end

      def no_company_timecode_hours
        general_message_format("There are no hours logged for the timecodes")
      end

      def no_client_hours
        general_message_format("There are no hours logged clients")
      end

      def invalid_client_selection_message
        general_message_format("Please enter a client number from the list")
      end

      def no_clients_message
        general_message_format("There are no clients")
      end

      def new_client_name_message
        general_message_format("Please enter the new client's name")
      end

      def no_log_times_message
        general_message_format("You do not have any log times for this month")
      end

      def menu_selection_message
        puts_space
        @io_wrapper.puts_string("Please select an option")
        puts_space
        @io_wrapper.puts_string("Enter the number next to the choice")
        puts_space
      end

      def display_menu_options(options_hash)
        @io_wrapper.puts_string("Please select an option from below")
        puts_space
        options_hash.each do |selection_num, option|
          @io_wrapper.puts_string(option)
        end
      end

      def date_log_time_message
        general_log_time_message("Date (MM-DD-YYYY)")
      end

      def hours_log_time_message
        general_log_time_message("Hours Worked")
      end

      def timecode_log_time_message(timecode_hash)
        puts_space
        puts_space
        display_menu_options(timecode_hash)
        get_user_input
      end

      def format_employee_report(log_times_sorted, client_hash, timecode_hash)
        puts_space
        @io_wrapper.puts_string("This is a report for the current month")

        puts_space

        @io_wrapper.puts_string("Date" + "            "  + "Hours Worked" + "            " + "Timecode" + "            " + "Client")
        log_times_sorted.each do |log_time|

          items_to_print = log_time[0] + "            " + log_time[1] + "                  " + log_time[2] 
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

      def format_admin_report(timecode_hash, client_hash)
        @io_wrapper.puts_string("This is a report for the current month")
        puts_space

        format_company_timecode_hours_worked(timecode_hash)
        puts_space

        display_client_hash(client_hash)
      end

      private 

      def general_log_time_message(display_string)
        puts_space
        @io_wrapper.puts_string(display_string)
        get_user_input
      end

      def display_client_hash(client_hash)
        client_hash ? format_company_client_hours_worked(client_hash) : no_client_hours
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

      def format_company_timecode_hours_worked(timecode_hash)
        timecode_hash.each do |timecode, hours_worked| 
          @io_wrapper.puts_string("Company total #{timecode} hours: #{hours_worked.to_s}")
        end
      end

      def format_company_client_hours_worked(client_hash)
        client_hash.each do |client, hours_worked|
          @io_wrapper.puts_string("Company total hours for #{client}: #{hours_worked.to_s}")
        end
      end

      def general_message_format(string)
        puts_space
        @io_wrapper.puts_string(string)
        puts_space
      end
    end
  end
end
