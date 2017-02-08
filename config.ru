$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'time_logger'
require 'time_logger/web/app'

#FILE_PATH = File.expand_path("../data/time_logger_data.json", __FILE__)
#file_wrapper =  InMemory::FileWrapper.new(FILE_PATH)
#json_store = InMemory::JsonStore.new(file_wrapper) 
#json_store.load   
connection = PG::Connection.open(:dbname => "time_logger")

repos = {
  :log_time_repo => SQL::LogTimeRepo.new(connection),
  :employee_repo => SQL::EmployeeRepo.new(connection),
  :client_repo => SQL::ClientRepo.new(connection)
}

#repos = {
#  :log_time_repo => InMemory::LogTimeRepo.new(json_store),
#  :employee_repo => InMemory::EmployeeRepo.new(json_store),
#  :client_repo => InMemory::ClientRepo.new(json_store)
#}

TimeLogger::RepositoryRegistry.setup(repos)

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
                                    log_time_repo
                                  )
params = { 
  client_repo: client_repo,
  employee_repo: employee_repo, 
  log_time_repo: log_time_repo,
  validation_client_creation: validation_client_creation,
  validation_employee_creation: validation_employee_creation, 
  validation_log_time: validation_log_time
}

at_exit {
#  file_wrapper.write_data(json_store.data)
  connection.close
}

run WebApp.new(app=nil,params)



