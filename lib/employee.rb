module TimeLogger
  class Employee
    
    def initialize(username, file_wrapper, file_name)
      @username = username
      @file_wrapper = file_wrapper
      file_wrapper.write_data(file_name, 
        { 
          "username":  "#{username}"
        })
    end

    
  end
end
