module TimeLogger
  require "spec_helper"


  describe Repository do

    let(:mock_save_json_data) { double }
  
    before(:each) do
      repositories_hash = {
        "log_time": LogTimeRepo.new(mock_save_json_data),
        "employee": EmployeeRepo.new(mock_save_json_data)
      }
    end

    describe ".repositories" do
      it "returns and empty hash when repos are not in hash" do
        expect(Repository.repositories).to be_a_kind_of(Hash)
      end
    end

    describe ".register" do
      it "adds repositories to the state of the object" do
          repo = LogTimeRepo.new(mock_save_json_data)

          Repository.register("log_time", repo)
          
          repo_instance_variable = Repository.repositories.values[0].entries

          expect(repo_instance_variable).to eq([])
      end
    end

    describe ".for" do
      it "returns the correct repository" do
        type = "log_time"
        repo_class = LogTimeRepo

        result = Repository.for(type)

        expect(result).to be_a_kind_of(repo_class)
      end
    end
  end
end
