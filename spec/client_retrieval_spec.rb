module TimeLogger
  require "spec_helper"

  describe ClientRetrieval do
    before(:each) do
      @mock_client_repo = double
      allow(Repository).to receive(:for).and_return(@mock_client_repo)
      @client_retrieval = ClientRetrieval.new
    end

    def setup_client
      Client.new(1, "Google")
    end

    describe ".find_client" do
      context "the client exists in the data" do
        it "returns a client object" do
          client = setup_client
          expect(@mock_client_repo).to receive(:find_by_name).with("Google").and_return(client)
          result = @client_retrieval.find_client("Google") 
          expect(result).to eq(client)
        end
      end

      context "the client does not exist in the data" do
        it "returns nil" do
          expect(@mock_client_repo).to receive(:find_by_name).with("Google").and_return(nil)
          result = @client_retrieval.find_client("Google")
          expect(result).to eq(nil)
        end
      end
    end
   
    describe ".save_client" do
      it "creates and saves an employee" do
        expect(@mock_client_repo).to receive(:create).with("Microsoft")
        expect(@mock_client_repo).to receive(:save)
        @client_retrieval.save_client("Microsoft")
      end
    end
  end
end
