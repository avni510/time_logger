#!/usr/bin/env ruby

require_relative "../lib/time_logger"

io_wrapper = TimeLogger::IOWrapper.new

console_ui = TimeLogger::ConsoleUI.new(io_wrapper)

file_path = "../time_logger/time_logger_data.json"

file_wrapper = TimeLogger::FileWrapper.new(file_path)

save_json_data = TimeLogger::SaveJsonData.new(file_wrapper)

console_runner = TimeLogger::ConsoleRunner.new(file_wrapper, save_json_data, console_ui)

console_runner.run


