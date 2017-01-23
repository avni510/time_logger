require "sinatra/base"
require "wannabe_bool"
require "sinatra/flash"

class WebApp < Sinatra::Base
  enable :sessions
  set :session_secret, "My session secret"
  register Sinatra::Flash

  def initialize(app = nil, params)
    @worker_retrieval = params[:worker_retrieval]
    @report_retrieval = params[:report_retrieval]
    @client_retrieval = params[:client_retrieval]
    @log_time_retrieval = params[:log_time_retrieval]
    @validation_client_creation = params[:validation_client_creation]
    @validation_employee_creation = params[:validation_employee_creation]
    @validation_log_time = params[:validation_log_time]
    super(app)
  end

  get '/' do
    @employees = @worker_retrieval.company_employees 
    erb :homepage, :layout => false
  end

  post '/login' do
    session[:username] = params[:username]
    redirect to("/menu_selection")
  end

  get '/menu_selection' do
    redirect to('/') unless session[:username]
    @employee = @worker_retrieval.employee(session[:username])
    @admin = @employee.admin
    erb :menu_selection, :layout => false
  end

  get '/employee_report' do
    employee = @worker_retrieval.employee(session[:username])
    @sorted_log_times = @report_retrieval.log_times(employee.id)
    @client_hours = @report_retrieval.client_hours(employee.id)
    @timecode_hours = @report_retrieval.timecode_hours(employee.id)
    erb :employee_report
  end

  get "/admin_report" do
    @company_timecodes = @report_retrieval.company_wide_timecode_hours
    @company_clients = @report_retrieval.company_wide_client_hours
    erb :admin_report
  end

  get "/employee_creation" do
    erb :employee_creation
  end

  post "/employee_creation_submission" do
    result = @validation_employee_creation.validate(params[:new_user])
    unless result.valid?
      flash[:error] = result.error_message
      redirect "/employee_creation"
    else
      @worker_retrieval.save_employee(params[:new_user], params[:admin_authority].to_b)
      @success_message = "You have successfully created a new employee"
      erb :submission_success
    end
  end

  get "/client_creation" do
    erb :client_creation 
  end

  post "/client_creation_submission" do
    result = @validation_client_creation.validate(params[:new_client])
    unless result.valid?
      flash[:error] = result.error_message
      redirect "/client_creation"
    else
      @client_retrieval.save_client(params[:new_client])
      @success_message = "You have successfully created a new client"
      erb :submission_success
    end
  end

  get "/log_time" do
    @clients = @client_retrieval.find_all
    erb :log_time
  end

  post "/log_time_submission" do
    employee = @worker_retrieval.employee(session[:username])
    log_time_hash = { 
      date: params[:date], 
      hours_worked: params[:hours_worked], 
      employee_id: employee.id 
    }
    result = @validation_log_time.validate(log_time_hash) 
    unless result.valid?
      flash[:error] = result.error_message
      redirect "/log_time"
    else
      if params[:client] == "None"
        @log_time_retrieval.save_log_time_entry(
          employee.id, 
          params[:date], 
          params[:hours_worked], 
          params[:timecode], 
          nil
        )
      else
        @log_time_retrieval.save_log_time_entry(
          employee.id, 
          params[:date], 
          params[:hours_worked], 
          params[:timecode], 
          params[:client]
        )
      end
      @success_message = "You have successfully logged your time"
      erb :submission_success
    end
  end
end
