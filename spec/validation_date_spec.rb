module TimeLogger
  require "spec_helper" 

  describe ValidationDate do
    let(:validation_date) { ValidationDate.new }

    describe ".validate" do
      context "the date entered is in an invalid format" do
        it "returns an instance of the result object with the proper errors" do
          invalid_date_message = "Please enter a date in a valid format"
          [ 
            ["09-19-2016", nil],
            ["000000000", invalid_date_message],
            ["02-12-16", nil],
            ["02-12-20-16", invalid_date_message],
            ["02-30-2016", invalid_date_message]
          ].each do |date_entered, value|
            result = validation_date.validate(date_entered)
            expect(result.errors).to eq(value)
          end
        end
      end

      context "returns true if the date entered is prior to the current date  and false otherwise" do
        it "returns an instance of the result object with the proper errors" do
          allow(Date).to receive(:today).and_return(Date.new(2016, 9, 28))
          invalid_date_message = "Please enter a date in the past" 
          [ 
            ["10-05-2016", invalid_date_message], 
            ["02-02-2020", invalid_date_message],
            ["09-10-2016", nil ]
          ].each do |date_entered, value|
            result = validation_date.validate(date_entered)
            expect(result.errors).to eq(value)
          end
        end
      end
    end
  end
end
