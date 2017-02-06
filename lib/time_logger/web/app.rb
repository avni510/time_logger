require "sinatra/base"
require "wannabe_bool"
require "sinatra/flash"

class WebApp < Sinatra::Base
  enable :sessions
  set :session_secret, "My session secret"
  register Sinatra::Flash

  def initialize(app = nil, params)
    @client_repo = params[:client_repo]
    @employee_repo = params[:employee_repo]
    @log_time_repo = params[:log_time_repo]
    @validation_client_creation = params[:validation_client_creation]
    @validation_employee_creation = params[:validation_employee_creation]
    @validation_log_time = params[:validation_log_time]
    super(app)
  end

  get '/' do
    @employees = @employee_repo.all
    erb :homepage, :layout => false
  end

  post '/login' do
    session[:username] = params[:username]
    redirect to("/menu_selection")
  end

  get '/menu_selection' do
    redirect to('/') unless session[:username]
    @employee = @employee_repo.find_by_username(session[:username])
    if @employee
      erb :menu_selection, :layout => false
    else
      flash[:error] = "This user does not exist"
      redirect to('/')
    end
  end

  get '/employees/:id/report' do
    employee = @employee_repo.find_by_username(session[:username])
    @sorted_log_times = @log_time_repo.sorted_current_month_entries_by_employee_id(employee.id)
    @client_hours = @log_time_repo.employee_client_hours(employee.id)
    @timecode_hours = @log_time_repo.employee_timecode_hours(employee.id)
    erb :employee_report
  end

  get "/employees/:id/company_report" do
    @company_timecodes = @log_time_repo.company_timecode_hours
    @company_clients = @log_time_repo.company_client_hours
    erb :admin_report
  end

  get "/employees/new" do
    erb :employee_creation
  end

  post "/employees" do
    result = @validation_employee_creation.validate(params[:new_user])
    unless result.valid?
      flash[:error] = result.error_message
      redirect "/employees/new"
    else
      @employee_repo.create(params[:new_user], params[:admin_authority].to_b)
      @success_message = "You have successfully created a new employee"
      erb :submission_success
    end
  end

  get "/clients/new" do
    erb :client_creation 
  end

  post "/clients" do
    result = @validation_client_creation.validate(params[:new_client])
    unless result.valid?
      flash[:error] = result.error_message
      redirect "/clients/new"
    else
      @client_repo.create(params[:new_client])
      @success_message = "You have successfully created a new client"
      erb :submission_success
    end
  end

  get "/log_times/new" do
    @clients = @client_repo.all
    erb :log_time
  end

  post "/log_times" do
    employee = @employee_repo.find_by_username(session[:username])
    log_time_hash = { 
      date: params[:date], 
      hours_worked: params[:hours_worked], 
      employee_id: employee.id 
    }
    result = @validation_log_time.validate(log_time_hash) 
    unless result.valid?
      flash[:error] = result.error_message
      redirect "/log_times/new"
    else
      log_time_entry = { 
        employee_id: employee.id,
        date: Date.strptime(params[:date], '%m-%d-%Y').to_s,
        hours_worked: params[:hours_worked],
        timecode: params[:timecode]
      }
      if params[:client] == "None"
        log_time_entry[:client] = nil
      else
        log_time_entry[:client] = params[:client]
      end
      @log_time_repo.create(log_time_entry)
      @success_message = "You have successfully logged your time"
      erb :submission_success
    end
  end
end
