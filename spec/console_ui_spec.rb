module TimeLogger
  require "spec_helper"

  describe ConsoleUI do
    let(:mock_io_wrapper) { double }
    let(:console_ui) { ConsoleUI.new(mock_io_wrapper) }

    describe ".puts_space" do
      it "displays a space" do
        expect(mock_io_wrapper).to receive(:puts_string).with("")
        console_ui.puts_space
      end
    end

    describe ".username_display_message" do
      it "asks the user for their username" do
        expect(mock_io_wrapper).to receive(:puts_string).with("Please enter your username")
        expect(console_ui).to receive(:puts_space)
        console_ui.username_display_message
      end
    end

    describe ".get_user_input" do 
      it "prompts the user for input" do
        expect(mock_io_wrapper).to receive(:get_action).exactly(1).times
        expect(console_ui).to receive(:puts_space)
        console_ui.get_user_input
      end
    end

    describe ".new_client_name_message" do
      it "displays a message to enter the name of a client" do
        expect(mock_io_wrapper).to receive(:puts_string).with("Please enter the new client's name")
        expect(console_ui).to receive(:puts_space)
        console_ui.new_client_name_message
      end
    end

    describe ".enter_new_username_message" do
      context "an admin selects the option to create a new user" do
        it "displays a message to enter the new username" do
          expect(mock_io_wrapper).to receive(:puts_string).with("Please enter the username you would like to create")
          expect(console_ui).to receive(:puts_space)
          console_ui.enter_new_username_message
        end
      end
    end

    describe ".create_admin_message" do
      context "an admin creates a new user" do
        it "displays a message to ask the user if they would like the new user to be an admin or not" do
          expect(mock_io_wrapper).to receive(:puts_string).with("Would you like the user to be an admin?")
          expect(console_ui).to receive(:puts_space)
          console_ui.create_admin_message
        end
      end
    end

    describe ".client_exists_message" do
      context "an admin enters a client name that already exists" do
        it "displays a message to the user to enter a different client name" do
          expect(mock_io_wrapper).to receive(:puts_string).with("This client already exists, please enter a different one")
          expect(console_ui).to receive(:puts_space)
          console_ui.client_exists_message
        end
      end
    end

    describe ".username_exists_message" do
      context "an admin enters a username that already exists" do
        it "displays a message to the user to enter a different user name" do
          expect(mock_io_wrapper).to receive(:puts_string).with("This username already exists, please enter a different one")
          expect(console_ui).to receive(:puts_space)
          console_ui.username_exists_message
        end
      end
    end

    describe ".no_log_times_message" do
      context "there are no log times for a give user" do
        it "displays a message to the user that there are no log times" do
          expect(mock_io_wrapper).to receive(:puts_string).with("You do not have any log times for this month")
          expect(console_ui).to receive(:puts_space)
          console_ui.no_log_times_message
        end
      end
    end

    describe ".username_does_not_exist_message" do
      context "the username entered does not exist in the data" do
        it "displays the a message that it does not exist" do
          expect(mock_io_wrapper).to receive(:puts_string).with("This username does not exist")
          expect(console_ui).to receive(:puts_space)
          console_ui.username_does_not_exist_message
        end
      end
    end

    describe ".valid_hours_message" do
      context "more than 24 hours are entered in" do
        it "displays a message to the user to enter a valid input" do
          expect(mock_io_wrapper).to receive(:puts_string).with("You have exceeded 24 hours for this day.")
          expect(console_ui).to receive(:puts_space)
          console_ui.valid_hours_message
        end
      end
    end

    describe ".valid_username_message" do
      context "an invalid username is entered" do
        it "asks the user to enter a valid username" do
          expect(mock_io_wrapper).to receive(:puts_string).with("Please enter a valid username")
          expect(console_ui).to receive(:puts_space)
          console_ui.valid_username_message
        end
      end
    end

    describe ".valid_menu_option_message" do
      context "an invalid menu option is selected" do
        it "asks the user to enter a valid menu option" do
          expect(mock_io_wrapper).to receive(:puts_string).with("Please enter a valid menu option")
          expect(console_ui).to receive(:puts_space)
          console_ui.valid_menu_option_message
        end
      end
    end

    describe ".valid_date_message" do
      context "the user doesn't enter a date in the proper format" do
        it "displays a message to enter a valid date" do
          expect(mock_io_wrapper).to receive(:puts_string).with("Please enter a valid date")
          expect(console_ui).to receive(:puts_space)
          console_ui.valid_date_message
        end
      end
    end

    describe ".future_date_valid_message"do
      context "the user enters a date in the correct format and the date is in the future" do
        it "displays a message to enter a previous date" do
          expect(mock_io_wrapper).to receive(:puts_string).with("Please enter a date in the past")
          expect(console_ui).to receive(:puts_space)
          console_ui.future_date_valid_message
        end
      end
    end

    describe ".enter_digit_message" do
      context "the user enters a non digit for hours worked" do
        it "displays a message to enter a number" do
          expect(mock_io_wrapper).to receive(:puts_string).with("Please enter a number")
          expect(console_ui).to receive(:puts_space)
          console_ui.enter_digit_message
        end
      end
    end

    describe ".menu_selection_message" do
      it "displays a message to the user to select an option from the menu" do
        expect(mock_io_wrapper).to receive(:puts_string).with("Please select an option") 
        expect(console_ui).to receive(:puts_space).exactly(2).times
        expect(mock_io_wrapper).to receive(:puts_string).with("Enter the number next to the choice")
        console_ui.menu_selection_message
      end
    end
    
    describe ".display_menu_options" do
      it "displays the menu options" do
        employee_menu_options = 
          {
            "1" => "1. Do you want to log your time?", 
            "2" => "2. Do you want to run a report for the current month?" 
          }

        expect(mock_io_wrapper).to receive(:puts_string).exactly(2).times
        expect(console_ui).to receive(:puts_space)
        console_ui.display_menu_options(employee_menu_options)
      end
    end

    describe ".date_log_time_message" do
      it "displays a message to the user to enter the date to log time for" do
        expect(mock_io_wrapper).to receive(:puts_string).with("Date (MM-DD-YYYY)")
        expect(console_ui).to receive(:get_user_input)
        console_ui.date_log_time_message
      end
    end

    describe ".hours_log_time_message" do
      it "displays a message to the user to enter the hours worked" do
        expect(mock_io_wrapper).to receive(:puts_string).with("Hours Worked")
        expect(console_ui).to receive(:get_user_input)
        console_ui.hours_log_time_message
      end
    end

    describe ".timecode_log_time_message" do
      it "displays a message to the user to enter their timecode" do
        timecode_hash = {
          "1" => "1. Billable Work",
          "2" => "2. Non-Billable Work", 
          "3" => "3. PTO"
        }

        expect(console_ui).to receive(:display_menu_options).with(timecode_hash)

        expect(console_ui).to receive(:get_user_input)
        console_ui.timecode_log_time_message(timecode_hash)
      end
    end

    describe ".format_employee_report" do
      it "given an array of log times it returns a report for the employee" do
        log_times_sorted = [
          [ "09-02-2016", "7", "Billable", "Microsoft" ],
          [ "09-04-2016", "5", "Billable", "Microsoft" ],
          [ "09-06-2016", "6", "Non-Billable", nil ],
          [ "09-07-2016","10", "Billable", "Google" ],
          [ "09-08-2016", "5", "PTO", nil ]
        ]

        expect(mock_io_wrapper).to receive(:puts_string).with("This is a report for the current month")

        expect(console_ui).to receive(:puts_space).exactly(4).times

        expect(mock_io_wrapper).to receive(:puts_string).with("Date" + "            "  + "Hours Worked" +            "            " + "Timecode" + "            " + "Client")

        expect(mock_io_wrapper).to receive(:puts_string).with("09-02-2016" + "            "  + "7" + "            " + "Billable" + "            " + "Microsoft")

        expect(mock_io_wrapper).to receive(:puts_string).with("09-04-2016" + "            "  + "5" + "            " + "Billable" + "            " + "Microsoft")

        expect(mock_io_wrapper).to receive(:puts_string).with("09-06-2016" + "            "  + "6" + "            " + "Non-Billable")

        expect(mock_io_wrapper).to receive(:puts_string).with("09-07-2016" + "            "  + "10" + "            " + "Billable" + "            " + "Google")

        expect(mock_io_wrapper).to receive(:puts_string).with("09-08-2016" + "            "  + "5" + "            " + "PTO")


        total_hours_worked_per_client = { "Google": "10", "Microsoft": "12" }

        expect(mock_io_wrapper).to receive(:puts_string).with("Total hours worked for Google" + " : " + "10") 

        expect(mock_io_wrapper).to receive(:puts_string).with("Total hours worked for Microsoft" + " : " + "12") 

        total_hours_worked_per_timecode = { "Billable": "22", "Non-Billable": "6", "PTO": "5" }

        expect(mock_io_wrapper).to receive(:puts_string).with("Total Billable hours worked" + " : " + "22") 

        expect(mock_io_wrapper).to receive(:puts_string).with("Total Non-Billable hours worked" + " : " + "6") 

        expect(mock_io_wrapper).to receive(:puts_string).with("Total PTO hours worked" + " : " + "5") 

        console_ui.format_employee_report(log_times_sorted, total_hours_worked_per_client, total_hours_worked_per_timecode)
      end
    end

    describe ".format_clients_hash" do
      it "displays a list of clients when the user selects Billable as their timecode" do
        expect(mock_io_wrapper).to receive(:puts_string).with("1. Google")
        expect(mock_io_wrapper).to receive(:puts_string).with("2. Microsoft")

        expect(console_ui).to receive(:puts_space).exactly(2).times
        clients_hash = 
          {
            "1" => "Google", 
            "2" => "Microsoft"
          }

        console_ui.format_clients_hash(clients_hash)
      end
    end
  end
end
