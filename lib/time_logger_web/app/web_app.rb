require "sinatra/base"

class WebApp < Sinatra::Base
  enable :sessions
  def initialize(app = nil, params)
    @worker_retrieval = params[:worker_retrieval]
    load_data = params[:load_data]
    load_data.run
    super(app)
  end

  get '/' do
    @employees = @worker_retrieval.company_employees 
    erb :homepage
  end

  post '/menu_selection' do
    @employee = @worker_retrieval.employee(params[:username])
    session[:username] = params[:username]
    @admin = @employee.admin
    erb :menu_selection
  end
end
