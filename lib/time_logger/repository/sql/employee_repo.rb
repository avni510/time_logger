module SQL
  class EmployeeRepo

    def initialize(db_connection)
      @connection = db_connection
    end

    def create(username, admin=false)
      @connection.exec(
        "INSERT INTO EMPLOYEES (username, admin) values('#{username}', #{admin})"
      )
    end

    def find_by(id)
      result = @connection.exec(
        "SELECT * FROM EMPLOYEES WHERE id=#{id}"
      )
      return nil if result.values.empty?
      employee_list = result.values[0]
      create_employee_object(employee_list)
    end
    
    def find_by_username(username)
      result = @connection.exec(
        "SELECT * FROM EMPLOYEES WHERE username='#{username}'"
      )
      return nil if result.values.empty?
      employee_list = result.values[0]
      create_employee_object(employee_list)
    end

    def all
      result = @connection.exec(
        "SELECT * FROM EMPLOYEES"
      )
      return nil if result.values.empty?
      result.values.map do |employee_list|
        create_employee_object(employee_list)
      end
    end

    private

    def create_employee_object(values)
      id = values[0].to_i
      username = values[1]
      admin = convert_to_boolean(values[2])
      TimeLogger::Employee.new(id, username, admin) 
    end 

    def convert_to_boolean(value)
      value == "t" ? true : false
    end
  end
end
