module TimeLogger
  require "spec_helper"

  describe ClientCreation do 

    before(:each) do
      repositories_hash = 
        {
          "client": double
        }
      @repository = Repository.new(repositories_hash)
      @mock_client_repo = @repository.for(:client)

      @mock_console_ui = double
      @client_creation = ClientCreation.new(@mock_console_ui)
    end

    describe ".execute" do
      before(:each) do
        allow(@mock_console_ui).to receive(:new_client_name_message)
        allow(@mock_console_ui).to receive(:client_exists_message)
        allow(@mock_client_repo).to receive(:create)
        allow(@mock_client_repo).to receive(:save)
      end

      context "client name does not exist in memory" do
        it "prompts the user to enter a client name and saves it" do
          expect(@mock_console_ui).to receive(:new_client_name_message)

          expect(@mock_console_ui).to receive(:get_user_input).and_return("Google")

          allow(@mock_client_repo).to receive(:find_by).and_return(nil)

          expect(@mock_client_repo).to receive(:create).with("Google")

          expect(@mock_client_repo).to receive(:save)

          @client_creation.execute(@repository)
        end
      end

      context "client name exists in memory" do
        it "prompts the user to enter a client name and saves it" do

          expect(@mock_console_ui).to receive(:get_user_input).and_return("Google", "Microsoft")

          expect(@mock_client_repo).to receive(:find_by).and_return( Client.new(1, "Google"), nil)

          @client_creation.execute(@repository)
        end
      end
    end
  end
end
