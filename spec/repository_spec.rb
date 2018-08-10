require "spec_helper"
module TimeLogger
  describe Repository do

    let(:mock_json_store) { double }
    describe ".repositories" do
      it "returns and empty hash when repos are not in hash" do
        expect(Repository.repositories).to be_a_kind_of(Hash)
      end
    end

    describe ".register" do
      it "adds repositories to the state of the object" do
        repo = InMemory::LogTimeRepo.new(mock_json_store)
        Repository.register("log_time", repo)
        repo_class = InMemory::LogTimeRepo
        expect(Repository.repositories[:log_time]).
          to be_a_kind_of(repo_class)
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
