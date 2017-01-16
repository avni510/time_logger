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
    load_data = params[:load_data]
    load_data.run
    super(app)
  end

  get '/' do
    @employees = @worker_retrieval.company_employees 
    erb :homepage
  end

  post '/login' do
    session[:username] = params[:username]
    redirect to("/menu_selection")
  end

  get '/menu_selection' do
    redirect to('/') unless session[:username]
    @employee = @worker_retrieval.employee(session[:username])
    @admin = @employee.admin
    erb :menu_selection
  end

  get '/employee_report' do
    employee = @worker_retrieval.employee(session[:username])
    @sorted_log_times = @report_retrieval.log_times(employee.id)
    @client_hours = @report_retrieval.client_hours(employee.id)
    @timecode_hours = @report_retrieval.timecode_hours(employee.id)
    erb :employee_report
  end

  get "/back_to_menu_selection" do
    redirect to('/menu_selection')
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
    @employee = @worker_retrieval.employee(params[:new_user])
    if @employee 
      flash[:employee_exists] = "This user already exists, please create another user"
      redirect "/employee_creation"
    else
      @worker_retrieval.save_employee(params[:new_user], params[:admin_authority].to_b)
      erb :employee_creation_submission
    end
  end
end
