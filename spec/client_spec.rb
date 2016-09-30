module TimeLogger
  require "spec_helper"

  describe Client do

    before(:each) do
      id = 1
      name = "Google"
      @client = Client.new(1, "Google")
    end

    it "returns the client id" do
      expect(@client.id).to eq(1)
    end

    it "returns the client name" do
      expect(@client.name).to eq("Google")
    end

  end
end
