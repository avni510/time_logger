module TimeLogger
  require "spec_helper"


  describe Repository do
  
    before(:each) do
      repositories_hash = {
        "log_time": LogTimeRepo.new,
        "employee": EmployeeRepo.new
      }

      @repository = Repository.new(repositories_hash)
    end

    describe ".for" do
      it "returns the correct repository" do
        [ 
          [:employee, EmployeeRepo],
          [:log_time, LogTimeRepo]
        ].each do |type, repo_class|

          result = @repository.for(type)

          expect(result).to be_a_kind_of(repo_class)
        end
      end
    end
  end
end
