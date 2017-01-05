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
    
    describe ".run" do
      context "the user exists in the data" do
        it "returns an employee object" do
          expect(@mock_employee_repo).to receive(:find_by_username).with("rstarr").and_return(@employee_1)
          @worker_retrieval.run("rstarr")
        end
      end

      context "the user does not exist in the data" do
        it "returns nil" do
          expect(@mock_employee_repo).to receive(:find_by_username).with("jlennon").and_return(nil)
          @worker_retrieval.run("jlennon")
        end
      end
    end
  end
end
