module TimeLogger
  class SaveData

    def initialize(file_wrapper, output_file)
      @file_wrapper = file_wrapper
      @output_file = output_file
    end

    def add_username(username)
      data_hash = @file_wrapper.read_data(@output_file)
      username_hash = generate_username_hash(username)
      data_hash["workers"] << username_hash
      @file_wrapper.write_data(@output_file, data_hash)
    end


    def add_log_time(username, date, hours_worked, timecode)
      data_hash = @file_wrapper.read_data(@output_file)

      workers_array = data_hash["workers"]
      worker_hash = generate_worker_hash(workers_array, username)
      log_time_hash = generate_log_time_hash(date, hours_worked, timecode)

      worker_hash["log_time"] << log_time_hash

      @file_wrapper.write_data(@output_file, data_hash)
    end

    private

    def generate_log_time_hash(date, hours_worked, timecode)
      {
        "date": date,
        "hours_worked": hours_worked,
        "timecode": timecode
      }
    end

    def generate_username_hash(username)
      { 
        "username": username, 
        "admin": false, 
        "log_time": []
      }
    end

    def generate_worker_hash(workers_array, username)
      workers_array.each do |worker|
        if worker["username"] == username
          return worker
        end
      end
    end
  end
end
