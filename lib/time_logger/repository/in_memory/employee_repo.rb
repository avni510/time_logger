module InMemory
  class EmployeeRepo

    def initialize(json_store)
      @store = json_store
    end

    def employees
      employees_array = @store.data["employees"]
      employees_array.map do |employee|
        TimeLogger::Employee.new(
          employee["id"], 
          employee["username"], 
          employee["admin"]
        )
      end
    end

    def create(username, admin=false)
      employee_id = employees.count + 1
      data_hash = 
        {
          "id": employee_id,
          "username": username,
          "admin": admin,
          "log_time": []
        }
      data_hash = JSON.parse(JSON.generate(data_hash))
      @store.data["employees"] << data_hash 
    end

    def find_by(id)
      employees.find { |employee| employee.id == id }
    end
    
    def find_by_username(username)
      employees.find { |employee| employee.username == username }
    end

    def all
      employees
    end
  end
end
