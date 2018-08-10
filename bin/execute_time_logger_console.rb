#!/usr/bin/env ruby
$LOAD_PATH << File.expand_path('../../lib', __FILE__)
#require "/Users/avnikothari/Desktop/resident_apprenticeship/time_logger/lib/time_logger/console/time_logger_console.rb"

require "time_logger/console/console"

io_wrapper = TimeLogger::Console::IOWrapper.new

console_ui = TimeLogger::Console::ConsoleUI.new(io_wrapper)

console_runner = TimeLogger::Console::ConsoleRunner.new(console_ui)

console_runner.run


