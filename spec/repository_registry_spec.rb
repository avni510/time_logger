require "spec_helper"
module TimeLogger
  describe RepositoryRegistry do
    let(:client_repo) { double }
    let(:employee_repo) { double }
    let(:log_time_repo) { double }

    describe ".setup" do
      it "registers the repositories" do
        params = {
          :log_time_repo => log_time_repo, 
          :employee_repo => employee_repo,
          :client_repo => client_repo
        }
        RepositoryRegistry.setup(params)
        expect(Repository.for(:log_time)).to eq(log_time_repo)
        expect(Repository.for(:client)).to eq(client_repo)
      end
    end
  end
end
