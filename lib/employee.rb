module TimeLogger

  class Employee
    attr_reader :username
    
    def initialize(username, save_data)
      @username = username
      @save_data = save_data
    end

    def create(username)
      @save_data.add_username(username)
    end
  end
end
