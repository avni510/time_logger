require 'pry'

module TimeLogger
  class SaveData

    def initialize(file_wrapper, output_file)
      @file_wrapper = file_wrapper
      @output_file = output_file
    end

    def add_username(username)
      data_hash = @file_wrapper.read_data(@output_file)
      username_hash = 
        { 
          "username": username, 
          "admin": false, 
          "log_time": []
        }
      data_hash["workers"] << username_hash
      @file_wrapper.write_data(@output_file, data_hash)
    end

    def add_date(date, username)
      data_hash = @file_wrapper.read_data(@output_file)

      workers_array = data_hash["workers"]
      worker_hash = nil

      workers_array.each do |worker|
        if worker["username"] == username
          worker_hash = worker
          break
        end
      end


      worker_hash["log_time"] << { "date": date }

      @file_wrapper.write_data(@output_file, data_hash)

    end
  end
end
