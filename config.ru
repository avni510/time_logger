$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'time_logger'
require 'time_logger/web/app'

FILE_PATH = File.expand_path("../time_logger_data.json", __FILE__)

file_wrapper =  TimeLogger::FileWrapper.new(FILE_PATH)
save_json_data = TimeLogger::SaveJsonData.new(file_wrapper)
load_data = TimeLogger::LoadDataToRepos.new(file_wrapper, save_json_data)
load_data.run

worker_retrieval =  TimeLogger::WorkerRetrieval.new
report_retrieval = TimeLogger::ReportRetrieval.new
client_retrieval = TimeLogger::ClientRetrieval.new
log_time_retrieval = TimeLogger::LogTimeRetrieval.new
validation_client_creation = TimeLogger::ValidationClientCreation.new(TimeLogger::Repository.for(:client))
validation_employee_creation = TimeLogger::ValidationEmployeeCreation.new(TimeLogger::Repository.for(:employee))
validation_date = TimeLogger::ValidationDate.new
validation_hours_worked = TimeLogger::ValidationHoursWorked.new
params = { 
  worker_retrieval: worker_retrieval, 
  report_retrieval: report_retrieval,
  client_retrieval: client_retrieval,
  log_time_retrieval: log_time_retrieval,
  validation_client_creation: validation_client_creation,
  validation_employee_creation: validation_employee_creation, 
  validation_date: validation_date,
  validation_hours_worked: validation_hours_worked
}

run WebApp.new(app = nil, params)
