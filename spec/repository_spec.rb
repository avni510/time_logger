require "spec_helper"
module TimeLogger

  describe Repository do

    let(:mock_save_json_data) { double }
  
    before(:each) do
      repositories_hash = {
        "log_time": InMemory::LogTimeRepo.new(mock_save_json_data),
        "employee": InMemory::EmployeeRepo.new(mock_save_json_data)
      }
    end

    describe ".repositories" do
      it "returns and empty hash when repos are not in hash" do
        expect(Repository.repositories).to be_a_kind_of(Hash)
      end
    end

    describe ".register" do
      it "adds repositories to the state of the object" do
          repo = InMemory::LogTimeRepo.new(mock_save_json_data)

          Repository.register("log_time", repo)
          
          repo_instance_variable = Repository.repositories.values[0].entries

          expect(repo_instance_variable).to eq([])
      end
    end

    describe ".for" do
      it "returns the correct repository" do
        type = "log_time"
        repo_class = InMemory::LogTimeRepo

        result = Repository.for(type)

        expect(result).to be_a_kind_of(repo_class)
      end
    end
  end
end
