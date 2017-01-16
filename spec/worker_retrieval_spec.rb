module TimeLogger
  require "spec_helper"

  describe WorkerRetrieval do
    before(:each) do
      @mock_employee_repo = double
      allow(Repository).to receive(:for).and_return(@mock_employee_repo)
      @employee_1 = setup_employee
      @worker_retrieval = WorkerRetrieval.new
    end

    def setup_employee
      Employee.new(1, "rstarr", false)
    end
    
    describe ".employee" do
      context "the user exists in the data" do
        it "returns an employee object" do
          expect(@mock_employee_repo).to receive(:find_by_username).with("rstarr").and_return(@employee_1)
          @worker_retrieval.employee("rstarr")
        end
      end

      context "the user does not exist in the data" do
        it "returns nil" do
          expect(@mock_employee_repo).to receive(:find_by_username).with("jlennon").and_return(nil)
          @worker_retrieval.employee("jlennon")
        end
      end
    end

    describe ".company_employees" do
      it "returns a list of all the employees in the company" do
        employees = [
          Employee.new(1, "rstarr", false),
          Employee.new(2, "jlennon", true)
        ]
        expect(@mock_employee_repo).to receive(:all).and_return(employees)

        @worker_retrieval.company_employees
      end
    end

    describe ".save_employee" do
      it "creates and saves an employee" do
        username = "gharrison"
        admin_authority = false
        expect(@mock_employee_repo).to receive(:create).with(username, admin_authority)
        expect(@mock_employee_repo).to receive(:save)
        @worker_retrieval.save_employee(username, admin_authority)
      end
    end
  end
end
