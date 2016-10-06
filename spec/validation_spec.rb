module TimeLogger
  require "spec_helper"

  describe Validation do
    let(:validation) { Validation.new }

    describe ".menu_selection_valid?" do
      timecode_hash = 
        {
          "1": "Billable", 
          "2": "Non-Billable", 
          "3": "PTO", 
        }

      login_menu_hash = 
        {
          "1": "1. Do you want to log your time?", 
          "2": "2. Do you want to run a report on yourself?", 
          "3": "3. Quit the program"
        }

      [               
        [timecode_hash, "1", true],
        [timecode_hash, "4", false],
        [login_menu_hash, "T", false],
        [login_menu_hash, "!", false],
        [login_menu_hash, "3", true],
      ].each do |hash, user_input, bool|
        it "returns true if a valid menu selection is entered otherwise false" do

          result = validation.menu_selection_valid?(hash, user_input)
        
          expect(result).to eq(bool)
        end
      end
    end

    describe ".date_valid?" do
      it "returns true if the date entered is in the format MM-DD-YYYY or MM-DD-YY and false otherwise" do
        [ 
          ["09-19-2016", true],
          ["000000000", false],
          ["02-12-16", true],
          ["02-12-20-16", false]
        ].each do |date_entered, bool|

          result = validation.date_valid_format?(date_entered)

          expect(result).to eq(bool)
        end
      end

      context "numbers are entered in the correct format"
      it "returns true if the date entered is an actual date and false otherwise" do
        [ 
          ["02-30-2016", false], 
          ["05-32-2016", false], 
          ["07-31-2015", true]
        ].each do |date_entered, bool|

          result = validation.date_valid_format?(date_entered)

          expect(result).to eq(bool)
        end
      end
    end

    describe ".previous_date?" do
      context "the date entered is in a valid format" do
        it "returns true if the date entered is prior to the current date  and false otherwise" do
          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
          [ 
            ["10-05-2016", false], 
            ["02-02-2020", false],
            ["09-10-2016", true ]
          ].each do |date_entered, bool|
            result = validation.previous_date?(date_entered)
            expect(result).to eq(bool)
          end
        end
      end
    end

    describe ".digit_entered?" do
      it "returns true if an integer is entered and false otherwise" do
        [ 
          ["r", false], 
          ["!", false],
          ["6", true],
          ["-1", false], 
          ["0", false],
          ["899999", true],
          ["helloworld", false],
          [" ", false],
          ["", false],
        ].each do |user_input, bool|
          result = validation.digit_entered?(user_input)
          expect(result).to eq(bool)
        end
      end
    end

    describe ".blank_space_entered?" do
      it "returns true if there is text entered and false otherwise" do
        [ 
          ["", true],
          ["   ", true],
          ["Google", false]
        ].each do |user_input, bool|
          result = validation.blank_space?(user_input)
          expect(result).to eq(bool)
        end
      end
    end

    describe ".hours_in_a_day_exceeded?" do
      context "the user enters a digit" do
        it "returns true if total hours worked in a day is less than 24 and false otherwise" do
          [
            [ 24, 2, false ],
            [ 10, 10, true ],
            [ 0, 10, true ]
          ].each do |past_hours_worked, hours_entered, bool|

            result = validation.hours_in_a_day_exceeded?(
                past_hours_worked,
                hours_entered
              )

            expect(result).to eq(bool)
          end
        end
      end
    end
  end
end
