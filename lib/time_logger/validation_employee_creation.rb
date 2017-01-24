module TimeLogger
  class ValidationEmployeeCreation
    include Validation

    def initialize(employee_repo)
      @employee_repo = employee_repo
    end
    
    def validate(username)
      return Result.new("Your input cannot be blank") if blank_space?(username)
      return Result.new("This user already exists, please enter a different one") if @employee_repo.find_by_username(username)
      Result.new
    end
  end
end
