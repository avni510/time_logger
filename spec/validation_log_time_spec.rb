require "spec_helper"
module TimeLogger

  describe ValidationLogTime do
    let (:validation_log_time) { ValidationLogTime.new(ValidationDate.new, ValidationHoursWorked.new, mock_log_time_repo) } 
    let (:mock_log_time_repo) {double}
    let (:employee_id) { 1 }
    
    it "returns an instance of a result object with the proper errors" do
      params = {:date => "01-16-2017"}
      result = validation_log_time.validate(params)
      expect(result.error_message).to eq(nil)
    end

    context "blank space is entered for date" do
      it "returns an instance of a result object with the proper errors" do
        params = {:date => ""}
        result = validation_log_time.validate(params)
        expect(result.error_message).to eq("Your input cannot be blank")
      end
    end

    context "blank space is entered for hours worked" do
      it "returns an instance of a result object with the proper errors" do
        params = {:hours_worked => ""}
        result = validation_log_time.validate(params)
        expect(result.error_message).to eq("Your input cannot be blank")
      end
    end

    context "an invalid date is entered" do
      it "returns an instance of a result object with the proper errors" do
        params = {:date => "99999"}
        result = validation_log_time.validate(params)
        expect(result.error_message).to eq("Please enter a date in a valid format")
      end
    end

    context "a date is entered in future " do
      it "returns an instance of a result object with the proper errors" do
        params = {:date => "01-20-2020"}
        result = validation_log_time.validate(params)
        expect(result.error_message).to eq("Please enter a date in the past")
      end
    end

    context "a non digit is entered for the number of hours" do
      it "returns an instance of a result object with the proper errors" do
        params = {:hours_worked => "zzz"}
        result = validation_log_time.validate(params)
        expect(result.error_message).to eq("Please enter a number greater than 0")
      end
    end

    context "more than 24 hours were worked for a specific day" do
      it "returns an instance of a result object with the proper errors" do
        params = {:date => "01-01-2017", :hours_worked => "15", :employee_id => employee_id } 
        expect(mock_log_time_repo).to receive(:find_total_hours_worked_for_date).with(params[:employee_id], params[:date]).and_return(11)
        result = validation_log_time.validate(params)
        expect(result.error_message).to eq("You have exceeded 24 hours for this day.") 
      end
    end
  end
end
