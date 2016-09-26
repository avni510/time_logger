#!/usr/bin/env ruby

require_relative "../lib/time_logger"

io_wrapper = TimeLogger::IOWrapper.new

console_ui = TimeLogger::ConsoleUI.new(io_wrapper)

file_path = "/Users/avnikothari/Desktop/8thlight/time_logger/time_logger_data.json"

file_wrapper = TimeLogger::FileWrapper.new

save_data = TimeLogger::SaveData.new(file_wrapper, file_path)

validation = TimeLogger::Validation.new

console_runner = TimeLogger::ConsoleRunner.new(console_ui, save_data, validation, file_path)

console_runner.run


