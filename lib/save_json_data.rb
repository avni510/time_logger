module TimeLogger
  class SaveJsonData

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


    def log_time(entries)
      data_hash = @file_wrapper.read_data(@output_file)

      workers_array = data_hash["workers"]
      workers_array.each do |worker|
        worker["log_time"] = []
        entries.each do |entry|
          if worker["id"] == entry.employee_id
            log_time_hash = generate_log_time_hash(entry.entry_id, entry.date, entry.hours_worked, entry.timecode, entry.client)
            worker["log_time"] << log_time_hash
          end
        end
      end

      @file_wrapper.write_data(@output_file, data_hash)
    end

    private

    def generate_log_time_hash(id, date, hours_worked, timecode, client)
      {
        "id": id,
        "date": date,
        "hours_worked": hours_worked,
        "timecode": timecode,
        "client": client
      }
    end

    def generate_username_hash(username)
      { 
        "id": 1, 
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
