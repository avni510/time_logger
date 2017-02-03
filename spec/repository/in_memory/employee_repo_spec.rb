require "spec_helper"
module InMemory

  describe EmployeeRepo do
    before(:each) do
      data = 
        [
          {
            "id": 1,
            "username": "defaultadmin",
            "admin": true,
            "log_time": [
              {
                "id": 1,
                "date": "2017-01-01",
                "hours_worked": 1,
                "timecode": "Non-Billable",
                "client": nil
              }
            ]
          },
          {
            "id": 2,
            "username": "rstarr",
            "admin": false,
            "log_time": [
              {
                "id": 2,
                "date": "2017-01-02",
                "hours_worked": 1,
                "timecode": "Non-Billable",
                "client": nil
              }
            ]
          }
        ]
      @employee_repo = EmployeeRepo.new(data) 
      @username = "jlennon"
      @admin = false
    end

    describe ".employees" do
      it "returns an array of employee objects from the data array" do
        expected_array = 
          [ 
            TimeLogger::Employee.new(1, "defaultadmin", true), 
            TimeLogger::Employee.new(2, "rstarr", false), 
          ]
        result_array = @employee_repo.employees
        expect(result_array[0].id).to eq(expected_array[0].id)
        expect(result_array[0].username).to eq(expected_array[0].username)
      end
    end

    describe ".create" do
      it "creates a new employee and adds to the the employees data" do
        @employee_repo.create(@username, @admin)
        result = @employee_repo.employees
        expect(result[0].username).to eq("defaultadmin")
        expect(result[1].username).to eq("rstarr")
        expect(result[2].username).to eq("jlennon")
      end
    end

    describe ".find_by" do
      it "takes in an employee id and returns an object that corresponds to that id" do
        result = @employee_repo.find_by(1)
        expect(result.id).to eq(1)
        expect(result.username).to eq("defaultadmin")
      end

      it "returns nil if the id does not exist" do
        nonexistent_id = 3
        result = @employee_repo.find_by(nonexistent_id)
        expect(result).to eq(nil)
      end
    end

    describe ".find_by_username" do
      it "returns an employee object for a given username" do
        @employee_repo.create(@username, @admin)
        result = @employee_repo.find_by_username(@username)
        expect(result.username).to eq(@username)
      end

      context "the username does not exist in memory" do
        it "returns nil" do
          nonexistent_username = "pmmcartney"
          result = @employee_repo.find_by_username(nonexistent_username)
          expect(result).to eq(nil)
        end
      end
    end

#    describe ".save" do
#      it "passes all the employees that need to be saved" do
#        employee_repo.create(@username, @admin)
#
#        employees = employee_repo.employees
#
#        expect(mock_save_json_data).to receive(:employees).with(employees)
#
#        employee_repo.save
#      end
#    end

    describe ".all" do
      it "returns a list of all the employee objects" do
        result = @employee_repo.all
        expect(result.count).to eq(2)
        expect(result[-1].username).to eq("rstarr")
      end
    end
  end
end
