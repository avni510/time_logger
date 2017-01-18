module TimeLogger
  class ValidationMenu

    def validate(menu_hash, user_input)
      return Result.new("Please enter a valid option") unless menu_selection_valid?(menu_hash, user_input)
      Result.new
    end

    private

    def menu_selection_valid?(menu_hash, user_input)
      menu_hash.key?(user_input) || menu_hash.key?(user_input.to_sym)
    end
  end
end
