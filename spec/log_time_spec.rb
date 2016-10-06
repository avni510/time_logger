module TimeLogger
  require 'spec_helper'

  describe LogTime do

    before(:each) do
      @mock_console_ui = double
      @validation = Validation.new
      @log_time = LogTime.new(@mock_console_ui, @validation)

      @mock_log_time_repo = double
      @mock_client_repo = double

      allow(Repository).to receive(:for).with(:log_time).and_return(@mock_log_time_repo)
      allow(Repository).to receive(:for).with(:client).and_return(@mock_client_repo)

      @employee_id = 1
    end

    describe ".execute" do
      before(:each) do
        allow(@mock_console_ui).to receive(:date_log_time_message).and_return("09-15-2016")

        allow(@mock_console_ui).to receive(:hours_log_time_message).and_return("8")

        allow(@mock_log_time_repo).to receive(:find_by_employee_id_and_date).and_return(nil)

        allow(@mock_log_time_repo).to receive(:find_total_hours_worked_for_date).and_return(0)

        allow(@mock_client_repo).to receive(:all).and_return( [ Client.new(1, "Google") ] )

        allow(@mock_console_ui).to receive(:timecode_log_time_message).and_return("2")

        allow(@mock_log_time_repo).to receive(:create)
        allow(@mock_log_time_repo).to receive(:save)
      end

      context "all fields entered are valid" do
        it "allows the user to enter the date, hours worked, and timecode" do

        expect(@mock_console_ui).to receive(:date_log_time_message).and_return("09-15-2016")

        expect(@mock_console_ui).to receive(:hours_log_time_message).and_return("8")

        timecode_hash = 
          { 
            "1": "1. Billable", 
            "2": "2. Non-Billable",
            "3": "3. PTO"
          }

        expect(@mock_console_ui).to receive(:timecode_log_time_message).with(timecode_hash).and_return("2")

        @log_time.execute(@employee_id)
        end
      end

      context "the date entered does not exist" do
        it "prompts the user to enter a valid date" do
          expect(@mock_console_ui).to receive(:date_log_time_message).and_return("06-31-2016")

          expect(@mock_console_ui).to receive(:valid_date_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")
          
          @log_time.execute(@employee_id)
        end
      end

      context "the date entered is in the future" do
        it "prompts the user to enter a previous date" do
          expect(@mock_console_ui).to receive(:date_log_time_message).and_return("11-20-2016")

          expect(@mock_console_ui).to receive(:future_date_valid_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("06-30-2016")

          @log_time.execute(@employee_id)
        end
      end

      context "the hours entered is a non digit" do
        it "prompts the user to enter a digit" do

          expect(@mock_console_ui).to receive(:hours_log_time_message).and_return("!")

          expect(@mock_console_ui).to receive(:enter_digit_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("8")

          @log_time.execute(@employee_id)
        end
      end

      context " a digit is entered for hours worked and more than 24 hours were logged for a specific date" do
        it "prompts the user to enter a valid number of hours" do

          allow(@mock_console_ui).to receive(:date_log_time_message).and_return("06-30-2016", "09-02-2016")

          allow(@mock_console_ui).to receive(:hours_log_time_message).and_return("5", "7")

          expect(@mock_log_time_repo).to receive(:find_total_hours_worked_for_date).and_return(20, 0)

          expect(@mock_console_ui).to receive(:valid_hours_message)

          allow(@mock_console_ui).to receive(:timecode_log_time_message).and_return("2")
          @log_time.execute(@employee_id)
        end
      end

      context "an invalid timecode is entered" do
        it "prompts the user to enter a menu option" do
          expect(@mock_console_ui).to receive(:timecode_log_time_message).and_return("4")

          expect(@mock_console_ui).to receive(:valid_menu_option_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("3")

          @log_time.execute(@employee_id)
        end
      end

      it "passes in the correct data to be saved" do
        allow(@mock_console_ui).to receive(:date_log_time_message).and_return("04-15-2016")

        allow(@mock_console_ui).to receive(:hours_log_time_message).and_return("8")

        allow(@mock_log_time_repo).to receive(:find_by_employee_id_and_date).with(@employee_id, "04-15-2016").and_return(nil)

        expect(@mock_console_ui).to receive(:timecode_log_time_message).and_return("2")

        params = 
          { 
            "employee_id": @employee_id,
            "date": "2016-04-15", 
            "hours_worked": "8",
            "timecode": "Non-Billable", 
            "client": nil
          }

        expect(@mock_log_time_repo).to receive(:create).with(params)

        expect(@mock_log_time_repo).to receive(:save)

        @log_time.execute(@employee_id)
      end
     
      context "the user selects 'Billable' as their timecode" do
        it "prompts the user to select their client" do
          expect(@mock_console_ui).to receive(:timecode_log_time_message).and_return("1")

          expect(@mock_client_repo).to receive(:all).and_return(
            [ 
              Client.new(1, "Google"), 
              Client.new(2, "Microsoft")
            ])

          clients_hash = 
            {
              1 => "1. Google",
              2 => "2. Microsoft" 
            }

          expect(@mock_console_ui).to receive(:display_menu_options).with(clients_hash)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("2")

          params = 
            { 
              "employee_id": @employee_id,
              "date": "2016-09-15", 
              "hours_worked": "8",
              "timecode": "Billable", 
              "client": "Microsoft"
            }

          expect(@mock_log_time_repo).to receive(:create).with(params)
            
          @log_time.execute(@employee_id)
        end
      end

      context "the user selects 'Billable' as their timecode and selects a client not on the list" do
        it "prompts them to enter a valid client" do
          expect(@mock_console_ui).to receive(:timecode_log_time_message).and_return("1")

          expect(@mock_client_repo).to receive(:all).and_return(
            [ 
              Client.new(1, "Google"), 
              Client.new(2, "Microsoft")
            ])

          clients_hash = 
            {
              1 => "1. Google",
              2 => "2. Microsoft" 
            }

          expect(@mock_console_ui).to receive(:display_menu_options).with(clients_hash)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("5", "2")

          expect(@mock_console_ui).to receive(:invalid_client_selection_message)
            
          @log_time.execute(@employee_id)
        end
      end

      context "there are no clients" do
        it "does not display the option to select 'Billable' as a timecode" do
          expect(@mock_client_repo).to receive(:all).and_return([])

          timecode_hash = 
            { 
              "1": "1. Non-Billable",
              "2": "2. PTO"
            }
              
          expect(@mock_console_ui).to receive(:timecode_log_time_message).with(timecode_hash)

          @log_time.execute(@employee_id)
        end
      end
    end
  end
end
