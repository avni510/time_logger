module TimeLogger

  class Employee
    attr_reader :id
    attr_reader :username
    attr_reader :admin
    
    def initialize(id, username, admin)
      @id = id
      @username = username
      @admin = admin
    end
  end
end
