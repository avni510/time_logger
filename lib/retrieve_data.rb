module TimeLogger
  class RetrieveData

    def initialize(file_wrapper, file_name)
      @file_wrapper = file_wrapper
      @file_name = file_name
    end

    def user_log_times(username)
      data_hash = @file_wrapper.read_data(@file_name)

      workers_array = data_hash["workers"]
      worker_hash = generate_worker_hash(workers_array, username)
      log_time_array = worker_hash["log_time"]
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
