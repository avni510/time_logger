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

          params_entry_1 = 
            { 
              "id": 1, 
              "employee_id": 1, 
              "date": "06-30-2016", 
              "hours_worked": "10", 
              "timecode": "PTO", 
              "client": nil 
            }

          params_entry_2 = 
            { 
              "id": 2, 
              "employee_id": 1, 
              "date": "06-30-2016", 
              "hours_worked": "12", 
              "timecode": "PTO", 
              "client": nil 
            }

          expect(@mock_log_time_repo).to receive(:find_by_employee_id_and_date).and_return(
            [ 
              LogTimeEntry.new(params_entry_1), 
              LogTimeEntry.new(params_entry_2)
            ], [])

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

        expect(@mock_log_time_repo).to receive(:create).with(@employee_id, "04-15-2016", "8", "Non-Billable")

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

          @log_time.execute(@employee_id)
        end
      end
    end
  end
end
