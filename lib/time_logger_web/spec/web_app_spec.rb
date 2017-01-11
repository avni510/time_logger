require "rack/test"
require "spec_helper"
require_relative "../app/web_app"
require_relative "../../time_logger.rb"

describe WebApp do

  include Rack::Test::Methods
  
  let(:employees) {
    [
      TimeLogger::Employee.new(1, "defaultadmin", true), 
      TimeLogger::Employee.new(2, "username2", false), 
    ]
  }
  let(:mock_load_data) { double(run: nil) }
  let(:mock_worker_retrieval) { double(company_employees: employees) }

  def app
    params = { load_data: mock_load_data, worker_retrieval: mock_worker_retrieval }
    WebApp.new(app = nil, params)
  end

  describe "GET usernames" do
    before(:each) do
      expect(mock_worker_retrieval).to receive(:company_employees)
    end

    it "loads the homepage" do
      get "/"
      expect(last_response).to be_ok
    end

    it "returns a list of usernames" do
      get "/"
      expect(last_response.body).to include("defaultadmin")
    end
  end

  describe "POST menu_selection" do

    it "loads a menu selection page" do
      expect(mock_worker_retrieval).to receive(:employee).and_return(employees.first)
      post "/menu_selection", :username => "defaultadmin"
      expect(last_response).to be_ok
    end

    context "the user is an admin" do
      it "loads a list of 5 options the user can select" do
        expect(mock_worker_retrieval).to receive(:employee).and_return(employees.first)
        post "/menu_selection", :username => "defaultadmin"
        expect(last_response.body).to include("Do you want to log your time?")
        expect(last_response.body).to include("Do you want to run a company report?")
      end
    end

    context "the user is not an admin" do
      it "loads a list of 2 options the user can select" do
        expect(mock_worker_retrieval).to receive(:employee).and_return(employees[1])
        post "/menu_selection", :username => "username2"
        expect(last_response.body).to_not include("Do you want to create a client")
        expect(last_response.body).to_not include("Do you want to create an employee")
        expect(last_response.body).to_not include("Do you want to run a company report")
      end
    end 

#    it "loads a menu selection page" do
#      post '/menu_selection', {}, { 'rack.session' => {username: "defaultadmin" } }
#      puts last_request.env['rack.session']["username"]
#    end
  end
end
