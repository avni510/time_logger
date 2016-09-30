module TimeLogger
  require "spec_helper"

  describe EmployeeRepo do
    let(:mock_save_json_data) { double }
    let(:employee_repo) { EmployeeRepo.new(mock_save_json_data) } 

    it "returns a list of employees stored in memory" do
      expect(employee_repo.employees).to eq([])
    end

    before(:each) do
      @username = "jlennon"
      @admin = false
    end

    describe ".create" do
      it "creates a new employee object and adds it to the list of employees" do
        employee_repo.create(@username, @admin)
        
        result = employee_repo.employees

        expect(result[0]).to be_a_kind_of(Employee)
      end
    end

    describe ".find_by" do
      context "the username exists in memory" do
        it "returns an employee object for a given username" do
          employee_repo.create(@username, @admin)

          result = employee_repo.find_by(@username)
          
          expect(result.username).to eq("jlennon")
        end
      end

      context "the username does not exist in memory" do
        it "returns nil" do
          employee_repo.create(@username, @admin)

          result = employee_repo.find_by("rstarr")

          expect(result).to eq(nil)
        end
      end
    end

    describe ".save" do
      it "passes all the employees that need to be saved" do
        employee_repo.create(@username, @admin)

        employees = employee_repo.employees

        expect(mock_save_json_data).to receive(:employees).with(employees)

        employee_repo.save
      end
    end

    describe ".all" do
      it "returns a list of all the employee objects" do
        employee_repo.create(@username, @admin)
        employee_repo.create("rstarr", false)
        employee_repo.create("gharrison", true)

        result = employee_repo.all

        expect(result.count).to eq(3)
        expect(result[-1].username).to eq("gharrison")
      end
    end
  end
end
