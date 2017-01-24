#!/usr/bin/env ruby

$LOAD_PATH << File.expand_path('../../lib', __FILE__)
require 'time_logger'
require 'time_logger/web/app'
require 'vegas'

FILE_PATH = File.expand_path("../../time_logger_data.json", __FILE__)

file_wrapper =  TimeLogger::FileWrapper.new(FILE_PATH)
save_json_data = TimeLogger::SaveJsonData.new(file_wrapper)
load_data = TimeLogger::LoadDataToRepos.new(file_wrapper, save_json_data)
worker_retrieval =  TimeLogger::WorkerRetrieval.new
report_retrieval = TimeLogger::ReportRetrieval.new
params = { 
  load_data: load_data, 
  worker_retrieval: worker_retrieval, 
  report_retrieval: report_retrieval 
}
Vegas::Runner.new(WebApp.new(app = nil, params), 'web_app')
