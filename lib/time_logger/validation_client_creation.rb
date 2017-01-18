module TimeLogger
  class ValidationClientCreation 
    include Validation

    def initialize(client_repo)
      @client_repo = client_repo
    end

    def validate(client_name)
      return Result.new("Your input cannot be blank") if blank_space?(client_name)
      return Result.new("This client already exists, please enter a different one") if @client_repo.find_by_name(client_name)
      Result.new
    end
  end
end
