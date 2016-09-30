module TimeLogger
  class SaveJsonData

    def initialize(file_wrapper)
      @file_wrapper = file_wrapper
    end

    def employees(employees)
      data_hash = @file_wrapper.read_data

      workers_array = data_hash["workers"]

      last_employee_entered = workers_array.count

      new_employees = []

      employees.each do |employee|
        if employee.id > last_employee_entered
          new_employees << employee
        end
      end

      new_employees.each do |employee|
        employee_hash = generate_employee_hash(employee.id, employee.username, employee.admin)
        workers_array << employee_hash
      end

      @file_wrapper.write_data(data_hash)
    end


    def log_time(entries)
      data_hash = @file_wrapper.read_data

      workers_array = data_hash["workers"]
      workers_array.each do |worker|
        worker["log_time"] = []
        entries.each do |entry|
          if worker["id"] == entry.employee_id
            log_time_hash = generate_log_time_hash(entry.id, entry.date, entry.hours_worked, entry.timecode, entry.client)
            worker["log_time"] << log_time_hash
          end
        end
      end

      @file_wrapper.write_data(data_hash)
    end

    def clients(clients)
      data_hash = @file_wrapper.read_data

      clients_array = data_hash["clients"]

      clients.each do |client|
        client_hash = generate_client_hash(client.id, client.name)
        clients_array << client_hash
      end

      @file_wrapper.write_data(data_hash)
    end

    private


    def generate_client_hash(id, name)
      {
        "id": id,
        "name": name
      }
    end

    def generate_log_time_hash(id, date, hours_worked, timecode, client)
      {
        "id": id,
        "date": date,
        "hours_worked": hours_worked,
        "timecode": timecode,
        "client": client
      }
    end

    def generate_employee_hash(id, username, admin)
      { 
        "id": id, 
        "username": username, 
        "admin": admin, 
        "log_time": []
      }
    end
  end
end
