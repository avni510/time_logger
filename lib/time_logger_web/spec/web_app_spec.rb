require "rack/test"
require "spec_helper"
require_relative "../app/web_app"
require_relative "../../time_logger.rb"

describe WebApp do

  include Rack::Test::Methods

  def set_up_log_time_entries
      params_entry_1 = 
        { 
          "id": 1, 
          "employee_id": 1, 
          "date": Date.strptime("01-03-2017",'%m-%d-%Y'), 
          "hours_worked": 6, 
          "timecode": "Non-Billable", 
          "client": nil 
        }
      params_entry_2 = 
        { 
          "id": 2, 
          "employee_id": 1, 
          "date": Date.strptime("01-04-2017",'%m-%d-%Y'), 
          "hours_worked": 8, 
          "timecode": "PTO", 
          "client": nil 
        }

      params_entry_3 = 
        { 
          "id": 3, 
          "employee_id": 1, 
          "date": Date.strptime("01-06-2017",'%m-%d-%Y'), 
          "hours_worked": 7, 
          "timecode": "Billable", 
          "client": "Google"
        }

      log_times = 
        [
          TimeLogger::LogTimeEntry.new(params_entry_1),
          TimeLogger::LogTimeEntry.new(params_entry_2),
          TimeLogger::LogTimeEntry.new(params_entry_3),
        ]
  end
  
  let(:employees) {
    [
      TimeLogger::Employee.new(1, "defaultadmin", true), 
      TimeLogger::Employee.new(2, "username2", false), 
    ]
  }
  let(:log_times_current_month) { set_up_log_time_entries }
  let(:mock_load_data) { double(run: nil) }
  let(:mock_worker_retrieval) { double(company_employees: employees) }
  let(:mock_report_retrieval) { double(log_times: log_times_current_month) }

  def app
    params = { 
      load_data: mock_load_data, 
      worker_retrieval: mock_worker_retrieval, 
      report_retrieval: mock_report_retrieval 
    }
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
  end

  describe "GET employee_report" do
    before(:each) do
      client_hours_hash = { "Google": "7" }
      timecode_hours_hash = { 
        "Non-Billable": "6", 
        "PTO": "8", 
        "Billable": "7"
      }
      allow(mock_worker_retrieval).to receive(:employee).and_return(employees.first)
      allow(mock_report_retrieval).to receive(:log_times).with(employees.first.id).and_return(set_up_log_time_entries)
      allow(mock_report_retrieval).to receive(:client_hours).with(employees.first.id).and_return(client_hours_hash)
      allow(mock_report_retrieval).to receive(:timecode_hours).with(employees.first.id).and_return(timecode_hours_hash)
    end

    it "loads an employee report page" do
      get "/employee_report", {}, { 'rack.session' => {username: "defaultadmin"} }
      expect(last_response).to be_ok
    end

    context "log times exist for an employee" do
      it "displays a report of log times, client hours, and timecode hours" do
        get "/employee_report", {}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.body).to include("Date")
        expect(last_response.body).to include("Client")
        expect(last_response.body).to include("Total hours worked for Google")
        expect(last_response.body).to include("Total Non-Billable hours worked")
      end
    end
    
    context "log times do not exist for an employee" do
      it "displays a message that there are no log times" do
        expect(mock_report_retrieval).to receive(:log_times).and_return(nil)
        expect(mock_report_retrieval).to receive(:client_hours).with(employees.first.id).and_return({})
        expect(mock_report_retrieval).to receive(:timecode_hours).with(employees.first.id).and_return({})


        get "/employee_report", {}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.body).to include("You have no log times")
      end
    end
  end
end
