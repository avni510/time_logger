module TimeLogger
  require "spec_helper"

  describe ValidationHoursWorked do
    let (:validation_hours_worked) { ValidationHoursWorked.new }

    describe ".validate" do
      context "the hours worked entered are not a digit" do
        it "returns an instance of the result object with the proper errors" do
          invalid_hours_worked_message = "Please enter a number greater than 0"

          [ 
            ["r", invalid_hours_worked_message], 
            ["!", invalid_hours_worked_message],
            ["6", nil],
            ["-1", invalid_hours_worked_message], 
            ["0", invalid_hours_worked_message],
            ["helloworld", invalid_hours_worked_message],
          ].each do |hours_worked, value|
            result = validation_hours_worked.validate(hours_worked)
            expect(result.error_message).to eq(value)
          end
        end
      end
    
    context "the user enters a digit but they have exceed 24 hours in a day" do
      it "returns an instance of the result object with the proper errors" do
        invalid_hours_worked_message = "You have exceeded 24 hours for this day."
        code = :exceeds_24_hours
          [
            [ 24, 2, invalid_hours_worked_message, code ],
            [ 10, 10, nil, nil ],
            [ 0, 10, nil, nil ]
          ].each do |past_hours_worked, hours_entered, value, code_value|

            result = validation_hours_worked.validate(
                past_hours_worked,
                hours_entered
              )

            expect(result.error_message).to eq(value)
            expect(result.code).to eq(code_value)
          end
        end
      end

      context "the user enters a blank space for the date" do
        it "returns an instance of the result object with the proper errors" do
          blank_space_message = "Your input cannot be blank"
          [ 
            ["", blank_space_message],
            ["   ", blank_space_message],
            ["20", nil]
          ].each do |user_input, value|
            result = validation_hours_worked.validate(user_input)
            expect(result.error_message).to eq(value)
          end
        end
      end
    end
  end
end
