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
      it "returns true if the date entered is in the correct format and false otherwise" do
        [ 
          ["09-19-2016", true],
          ["000000000", false],
          ["02-12-2016", true]
        ].each do |date_entered, bool|

          result = validation.date_valid?(date_entered)

          expect(result).to eq(bool)
        end
      end

      it "returns true if the date entered is valid date and false otherwise" do
        [ 
          ["02-30-2016", false], 
          ["05-32-2016", false], 
          ["07-31-2015", true]
        ].each do |date_entered, bool|

          result = validation.date_valid?(date_entered)

          expect(result).to eq(bool)
        end
      end
    end

    describe ".previous_date?" do
      context "the date entered is in a valid format" do
        it "returns true if the date entered is prior to the current day and false otherwise" do
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

    describe ".hours_worked_valid?" do
      it "returns true if hours worked entered is less than hours in a day and false otherwise" do
        [ 
          ["35", false],
          ["3", true],
          ["22", true]
        ].each do |hours_worked, bool|
          result = validation.hours_worked_valid?(hours_worked)

          expect(result).to eq(bool)
        end
      end
    end
  end
end
