module TimeLoggerConsole
  class IOWrapper

    def get_action
      gets.chomp
    end

    def puts_string(string)
      puts string
    end
  end
end

