require "spec_helper"
module SQL
  describe EmployeeRepo do
    let(:connection) { PG::Connection.open(:dbname => "time_logger_test") }  
    let(:employee_repo) { EmployeeRepo.new(connection) }

    after(:each) do
      connection.exec("DELETE FROM EMPLOYEES")
      connection.exec(
        "ALTER SEQUENCE employees_id_seq RESTART WITH 1"
      )
      connection.exec(
        "INSERT INTO EMPLOYEES (username, admin) VALUES ('defaultadmin', 'true')"
      )
    end

    after(:all) do
      PG::Connection.open(:dbname => "time_logger_test").close
    end

    describe ".create" do
      it "creates a new employee in the database" do
        username = "rstarr"
        admin = false
        employee_repo.create(username, admin)
        result = connection.exec(
          "SELECT * FROM EMPLOYEES WHERE username='rstarr'"
        )
        expect(result.values[0][1]).to eq("rstarr")
      end
    end

    describe ".find_by" do
      it "takes in an employee id and returns an object that corresponds to that id" do
        id = 2
        username = "rstarr"
        admin = false
        employee_repo.create(username, admin)
        result_employee = employee_repo.find_by(id) 
        expected_employee = 
          TimeLogger::Employee.new(2, "rstarr", false)
        expect(result_employee.id).to eq(expected_employee.id)
      end

      it "returns nil if the id does not exist" do
        id = 2
        username = "rstarr"
        admin = false
        employee_repo.create(username, admin)
        nonexistent_id = 3
        result_employee = employee_repo.find_by(nonexistent_id)
        expect(result_employee).to eq(nil) 
      end
    end

    describe ".find_by_username" do
      context "the username exists in memory" do
        it "returns an employee object for a given username" do
          id = 2
          username = "rstarr"
          admin = false
          employee_repo.create(username, admin)
          result_employee = employee_repo.find_by_username(username) 
          expected_employee = 
            TimeLogger::Employee.new(2, "rstarr", false)
          expect(result_employee.username).to eq(expected_employee.username)
        end
      end

      context "the username does not exist in memory" do
        it "returns nil" do
          id = 2
          username = "rstarr"
          admin = false
          employee_repo.create(username, admin)
          nonexistant_username = "gharrison"
          result_employee = employee_repo.find_by_username(nonexistant_username) 
          expect(result_employee).to eq(nil)
        end
      end
    end

    describe ".save" do
      it "passes all the employees that need to be saved" do
        employee_repo.save
      end
    end

    describe ".all" do
      it "returns a list of all the employee objects" do
        employee_repo.create("rstarr", false)
        employee_repo.create("gharrison", true)
        result_employees = employee_repo.all
        expected_employees = [
          [TimeLogger::Employee.new(1, "defaultadmin", true)],
          [TimeLogger::Employee.new(2, "rstarr", false)],
          [TimeLogger::Employee.new(3, "gharrsion", true)],
        ]
        expect(result_employees.count).to eq(3)
        expect(result_employees[1].username).to eq("rstarr")
      end

      context "there are no employees in the database" do
        before(:each) do
          connection.exec(
            "DELETE FROM EMPLOYEES WHERE username='defaultadmin'"
          )
        end

        it "returns nil" do
          expect(employee_repo.all).to eq(nil)  
        end
      end
    end
  end
end
