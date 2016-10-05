module TimeLogger
  class SaveJsonData

    def initialize(file_wrapper)
      @file_wrapper = file_wrapper
    end

    def employees(employees)
      data_hash = read_data

      workers = retrieve_workers_array(data_hash)

      last_employee_entered = workers.count
      
      new_employees = find_new_employees(employees, last_employee_entered)
      
      add_new_employees(workers, new_employees)

      write_data(data_hash)
    end

    def log_time(entries)
      data_hash = read_data

      workers = retrieve_workers_array(data_hash)

      add_log_times(workers, entries)

      write_data(data_hash)
    end

    def clients(clients)
      data_hash = read_data

      data_hash["clients"] = []
      
      add_clients(data_hash, clients)

      write_data(data_hash)
    end

    private

    def read_data
      @file_wrapper.read_data
    end

    def write_data(data_hash)
      @file_wrapper.write_data(data_hash)
    end

    def retrieve_workers_array(data_hash)
      data_hash["workers"]
    end

    def find_new_employees(employees, last_employee_entered)
      new_employees = []

      employees.each do |employee|
        if employee.id > last_employee_entered
          new_employees << employee
        end
      end
      new_employees
    end

    def add_new_employees(workers_array, new_employees)
      new_employees.each do |employee|
        employee_hash = generate_employee_hash(
          employee.id, 
          employee.username, 
          employee.admin)
        workers_array << employee_hash
      end
    end

    def add_log_times(workers, entries)
      workers.each do |worker|

        worker["log_time"] = []

        entries.each do |entry|
          if worker["id"] == entry.employee_id
            log_time_hash = generate_log_time_hash(
              entry.id, 
              entry.date.to_s, 
              entry.hours_worked, 
              entry.timecode, 
              entry.client)

            worker["log_time"] << log_time_hash
          end
        end
      end
    end

    def add_clients(data_hash, clients)
      clients.each do |client|
        client_hash = generate_client_hash(client.id, client.name)
        data_hash["clients"] << client_hash
      end
    end

    def generate_client_hash(id, name)
      {
        "id": id,
        "name": name
      }
    end

    def generate_log_time_hash(id, date, hours_worked, timecode, client)
      {
        "id": id,
        "date": date.to_s,
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
