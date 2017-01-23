require "rack/test"
require "spec_helper"

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
  let(:mock_client_repo) { double }
  let(:mock_employee_repo) { double(all: employees) }
  let(:mock_log_time_repo) { double }
  let(:validation_client_creation) {TimeLogger::ValidationClientCreation.new(mock_client_repo)}
  let(:validation_employee_creation) {TimeLogger::ValidationEmployeeCreation.new(mock_employee_repo)}
  let(:validation_date) {TimeLogger::ValidationDate.new}
  let(:validation_hours_worked) {TimeLogger::ValidationHoursWorked.new}
  let(:validation_log_time) { TimeLogger::ValidationLogTime.new(
                              validation_date, 
                              validation_hours_worked, 
                              mock_log_time_repo) 
                            }

  def app
    params = { 
      client_repo: mock_client_repo,
      employee_repo: mock_employee_repo,
      log_time_repo: mock_log_time_repo,
      validation_client_creation: validation_client_creation,
      validation_employee_creation: validation_employee_creation, 
      validation_log_time: validation_log_time
    }
    WebApp.new(app = nil, params)
  end

  describe "GET usernames" do
    before(:each) do
      expect(mock_employee_repo).to receive(:all)
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

  describe "POST login" do
    it "redirects to the menu_selection page" do
      post '/login', :username => "defaultadmin"
      expect(last_response.redirect?).to eq(true)
      follow_redirect!
      expect(last_request.path).to eq('/menu_selection')
    end
  end

  describe "GET menu_selection" do
    before(:each) do
      allow(mock_employee_repo).to receive(:find_by_username).and_return(employees.first)
    end

    it "loads a menu selection page" do
      get "/menu_selection", {}, { 'rack.session' => {username: "defaultadmin"}}
      expect(last_response).to be_ok
    end

    context "the user is an admin" do
      it "loads a list of 5 options the user can select" do
        get "/menu_selection", {}, { 'rack.session' => {username: "defaultadmin"}}
        expect(last_response.body).to include("Log Your Time")
        expect(last_response.body).to include("Run a Report on Yourself")
      end
    end

    context "the user is not an admin" do
      it "loads a list of 2 options the user can select" do
        expect(mock_employee_repo).to receive(:find_by_username).and_return(employees[1])
        get "/menu_selection", {}, { 'rack.session' => {username: "defaultadmin"}}
        expect(last_response.body).to_not include("Create a Client")
        expect(last_response.body).to_not include("Create an Employee")
        expect(last_response.body).to_not include("Run a Company Report")
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
      allow(mock_employee_repo).to receive(:find_by_username).and_return(employees.first)
      allow(mock_log_time_repo).to receive(:sorted_current_month_entries_by_employee_id).and_return(set_up_log_time_entries)
      allow(mock_log_time_repo).to receive(:employee_client_hours).with(employees.first.id).and_return(client_hours_hash)
      allow(mock_log_time_repo).to receive(:employee_timecode_hours).with(employees.first.id).and_return(timecode_hours_hash)
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
        expect(mock_log_time_repo).to receive(:sorted_current_month_entries_by_employee_id).and_return(nil)
        expect(mock_log_time_repo).to receive(:employee_client_hours).with(employees.first.id).and_return({})
        expect(mock_log_time_repo).to receive(:employee_timecode_hours).with(employees.first.id).and_return({})
        get "/employee_report", {}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.body).to include("You have no log times")
      end
    end
  end

  describe "GET /admin_report" do
    before(:each) do
      company_timecode_hash = 
        {
        "Billable" => 4, 
        "Non-Billable" => 6,
        "PTO" => 5
      }

      company_client_hash =  
        { 
        "Microsoft" => 5,
        "Google" => 3
      }
      allow(mock_log_time_repo).to receive(:company_timecode_hours).and_return(company_timecode_hash)
      allow(mock_log_time_repo).to receive(:company_client_hours).and_return(company_client_hash)
    end

    it "loads an admin report page" do
      get '/admin_report', {}, { 'rack.session' => {username: "defaultadmin" } }
      expect(last_response).to be_ok
    end

    context "log times exist in the company" do
      it "displays a report of total client hours and timecode hours for a company" do
        get '/admin_report', {}, { 'rack.session' => {username: "defaultadmin" } }
        expect(last_response.body).to include("Company total hours worked for Google : 3")
        expect(last_response.body).to include("Company total Billable hours worked : 4")
      end
    end

    context "There are no client hours worked" do
      it "displays a message that there are no client hours worked" do
        expect(mock_log_time_repo).to receive(:company_client_hours).and_return(nil)
        get '/admin_report', {}, { 'rack.session' => {username: "defaultadmin" } }
        expect(last_response.body).to include("There are no hours logged for clients")
      end
    end

    context "There are no log times" do
      it "displays a message that there are no log times for the company" do
        expect(mock_log_time_repo).to receive(:company_client_hours).and_return(nil)
        expect(mock_log_time_repo).to receive(:company_timecode_hours).and_return(nil)
        get '/admin_report', {}, { 'rack.session' => {username: "defaultadmin" } }
        expect(last_response.body).to include("There are no log times for the company")
        expect(last_response).to be_ok
      end
    end
  end

  describe "GET /employee_creation" do
    it "loads an employee creation page" do
      get '/employee_creation', {}, { 'rack.session' => {username: "defaultadmin" } }
      expect(last_response).to be_ok
    end

    it "allows the user to enter a new employee and choose to give them admin authority" do
      get '/employee_creation', {}, { 'rack.session' => {username: "defaultadmin" } }
      expect(last_response.body).to include("Please enter the username of the employee you would like to create")
      expect(last_response.body).to include("Please select from the dropdown if the user should have admin authority")
    end
  end

  describe "POST /employee_creation_submission" do
    before(:each) do
      allow(mock_employee_repo).to receive(:find_by_username).and_return(nil)
      allow(mock_employee_repo).to receive(:create)
      allow(mock_employee_repo).to receive(:save)
    end

    it "loads a page after a new user is submitted" do
      post "/employee_creation_submission", {:new_user => "username3", :admin_authority => "true"}
      expect(last_response).to be_ok
    end

    context "the newly created username does not already exist" do
      it "displays a success message and saves the user" do
        expect(mock_employee_repo).to receive(:create).with("username3", true)
        expect(mock_employee_repo).to receive(:save)
        post "/employee_creation_submission", {:new_user => "username3", :admin_authority => "true"}
        expect(last_response.body).to include("You have successfully created a new employee")
      end
    end

    context "a blank space is entered as the new user" do
      it "redirects them to the employee creation page and displays a message to enter a valid username" do
        post "/employee_creation_submission", {:new_user => "", :admin_authority => "true"}
        expect(last_response.redirect?).to eq(true) 
        follow_redirect!
        expect(last_request.path).to eq("/employee_creation")
        expect(last_response.body).to include("Your input cannot be blank")
      end
    end

    context "the newly created username already exists" do
      it "displays a message to create a new employee and redirects them to the employee creation page" do
        expect(mock_employee_repo).to receive(:find_by_username).and_return(employees.first)
        post "/employee_creation_submission", {:new_user => "defaultadmin", :admin_authority => "true"}
        expect(last_response.redirect?).to eq(true)
        follow_redirect!
        expect(last_request.path).to eq('/employee_creation')
        expect(last_response.body).to include("This user already exists, please enter a different one")
      end
    end
  end

  describe " GET /client_creation" do
    it "loads a client creation page" do
      get "/client_creation", {}, {'rack.session' => {username: "defaultadmin"}}
      expect(last_response).to be_ok
    end

    it "allows the user to enter a new client" do
      get "/client_creation", {}, {'rack.session' => {username: "defaultadmin"}}
      expect(last_response.body).to include("Please enter the name of the client you would like to create")
    end
  end

  describe "POST /client_creation_submission" do
    before(:each) do
      allow(mock_client_repo).to receive(:find_by_name).and_return(nil)
      allow(mock_client_repo).to receive(:create)
      allow(mock_client_repo).to receive(:save)
    end

    it "loads a page after a new client is submitted" do
      post "/client_creation_submission", {:new_client => "client1"}
      expect(last_response).to be_ok
    end

    context "the newly created client does not already exist" do
      it "displays a success message and saves the client" do
        post "/client_creation_submission", {:new_client => "client1"}
        expect(last_response.body).to include("You have successfully created a new client")
      end
    end

    context "a blank space is entered as the new client" do
      it "redirects them to the client creation page and displays a message to enter a valid client name" do
        post "/client_creation_submission", {:new_client => ""}
        expect(last_response.redirect?).to eq(true) 
        follow_redirect!
        expect(last_request.path).to eq("/client_creation")
        expect(last_response.body).to include("Your input cannot be blank")
      end
    end

    context "the newly created client already exists" do
      it "displays a message to create a new client and redirects them to the client creation page" do
        allow(mock_client_repo).to receive(:find_by_name).and_return(TimeLogger::Client.new(1, "clientname1"))
        post "/client_creation_submission", {:new_client => "clientname1"}
        expect(last_response.redirect?).to eq(true)
        follow_redirect!
        expect(last_request.path).to eq('/client_creation')
        expect(last_response.body).to include("This client already exists, please enter a different one")
      end
    end
  end

  describe "GET /log_time" do
    before(:each) do
      allow(mock_client_repo).to receive(:all).and_return([TimeLogger::Client.new(1, "clientname1")])
    end

    it "loads a page after a user selects the log time option from the menu" do
      get "/log_time", {}, { 'rack.session' => {username: "defaultadmin"} }
      expect(last_response).to be_ok
    end

    context "there are clients" do
      it "displays a form to log your time" do
        get "/log_time", {}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.body).to include("Please log your time")
        expect(last_response.body).to include("Date")
        expect(last_response.body).to include("Hours Worked")
        expect(last_response.body).to include("timecode")
        expect(last_response.body).to include("Billable")
        expect(last_response.body).to include("Please select your client from the dropdown")
      end
    end

    context "there are no clients" do
      it "displays a form to log your time" do
        expect(mock_client_repo).to receive(:all).and_return([])
        get "/log_time", {}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.body).to include("Please log your time")
        expect(last_response.body).to include("Date")
        expect(last_response.body).to include("Hours Worked")
        expect(last_response.body).to include("timecode")
        expect(last_response.body).to include("Non-Billable")
        expect(last_response.body).to include("PTO")
        expect(last_response.body).to_not include("Please select your client from the dropdown")
      end
    end
  end

  describe "POST /log_time_submission" do
    before(:each) do
      allow(mock_employee_repo).to receive(:find_by_username).and_return(employees.first)
      allow(mock_log_time_repo).to receive(:find_total_hours_worked_for_date).and_return(0)
      allow(mock_log_time_repo).to receive(:create)
      allow(mock_log_time_repo).to receive(:save)
    end

    context "the user enters a date in the incorrect format" do
      it "redirects them to the log_time page and displays a message to enter a valid date" do
        post "/log_time_submission", {:date => "9999", :hours_worked => "8"}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.redirect?).to eq(true)
        follow_redirect!
        expect(last_request.path).to eq('/log_time')
        expect(last_response.body).to include("Please enter a date in a valid format")
      end
    end

    context "the user enters a date in the future" do
      it "redirects them to the log_time page and displays a message to enter a date in the past" do
        post "/log_time_submission", {:date => "01-23-2020", :hours_worked => "8"}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.redirect?).to eq(true)
        follow_redirect!
        expect(last_request.path).to eq('/log_time')
        expect(last_response.body).to include("Please enter a date in the past")
      end
    end

    context "the user enters an invalid number of hours" do
      it "redirects them to the log_time page and displays a message to enter a number greater than 0" do
        post "/log_time_submission", {:date => "01-16-2017", :hours_worked => "zzz"}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.redirect?).to eq(true)
        follow_redirect!
        expect(last_request.path).to eq('/log_time')
        expect(last_response.body).to include("Please enter a number greater than 0")
      end
    end

    context "the user enters more than 24 hours for a given day" do
      it "redirects them to the log_time page and displays a message that they have exceeded 24 hours" do
        expect(mock_employee_repo).to receive(:find_by_username).and_return(employees.first)
        expect(mock_log_time_repo).to receive(:find_total_hours_worked_for_date).and_return(10)
        post "/log_time_submission", {:date => "01-03-2017", :hours_worked => "20"}, { 'rack.session' => {username: "defaultadmin"} }
        expect(last_response.redirect?).to eq(true)
        follow_redirect!
        expect(last_request.path).to eq('/log_time')
        expect(last_response.body).to include("You have exceeded 24 hours for this day.")
      end
    end

    context "all fields entered are valid and a client was entered" do
      it "saves the log time entry" do
        expect(mock_log_time_repo).to receive(:create).with(
          {
            employee_id: employees.first.id, 
            date: "2017-01-03", 
            hours_worked: "4", 
            timecode: "Billable", 
            client: "client1"
          }
        )
        post "/log_time_submission", {:date => "01-03-2017", :hours_worked => "4", :timecode => "Billable", :client => "client1"}, { 'rack.session' => {username: "defaultadmin"} }
      end
    end

    context "all fields entered are valid and a client was not entered" do
      it "saves the log time entry" do
        expect(mock_log_time_repo).to receive(:create).with(
          {
            employee_id: employees.first.id, 
            date: "2017-01-03", 
            hours_worked: "4", 
            timecode: "Non-Billable", 
            client: nil
          }
        )
        post "/log_time_submission", {:date => "01-03-2017", :hours_worked => "4", :timecode => "Non-Billable", :client => "None"}, { 'rack.session' => {username: "defaultadmin"} }
      end
    end
  end
end
