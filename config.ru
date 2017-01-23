$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'time_logger'
require 'time_logger/web/app'

FILE_PATH = File.expand_path("../time_logger_data.json", __FILE__)

file_wrapper =  TimeLogger::FileWrapper.new(FILE_PATH)
save_json_data = TimeLogger::SaveJsonData.new(file_wrapper)
load_data = TimeLogger::LoadDataToRepos.new(file_wrapper, save_json_data)
load_data.run

client_repo = TimeLogger::Repository.for(:client)
employee_repo = TimeLogger::Repository.for(:employee)
log_time_repo = TimeLogger::Repository.for(:log_time)
validation_client_creation = TimeLogger::ValidationClientCreation.new(client_repo)
validation_employee_creation = TimeLogger::ValidationEmployeeCreation.new(employee_repo)
validation_date = TimeLogger::ValidationDate.new
validation_hours_worked = TimeLogger::ValidationHoursWorked.new
validation_log_time = TimeLogger::ValidationLogTime.new(
                                    validation_date, 
                                    validation_hours_worked, 
                                    TimeLogger::Repository.for(:log_time)
                                  )
params = { 
  client_repo: client_repo,
  employee_repo: employee_repo, 
  log_time_repo: log_time_repo,
  validation_client_creation: validation_client_creation,
  validation_employee_creation: validation_employee_creation, 
  validation_log_time: validation_log_time
}

run WebApp.new(app = nil, params)
