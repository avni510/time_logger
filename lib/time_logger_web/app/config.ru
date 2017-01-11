require File.expand_path '../web_app.rb', __FILE__
require_relative "../../time_logger.rb"

FILE_PATH = File.expand_path("../../../../time_logger_data.json", __FILE__)

file_wrapper =  TimeLogger::FileWrapper.new(FILE_PATH)
save_json_data = TimeLogger::SaveJsonData.new(file_wrapper)
load_data = TimeLogger::LoadDataToRepos.new(file_wrapper, save_json_data)
worker_retrieval =  TimeLogger::WorkerRetrieval.new
params = { load_data: load_data, worker_retrieval: worker_retrieval }
run WebApp.new(app = nil, params)
