module InMemory
  class JsonStore
    attr_reader :data

    def initialize(file_wrapper)
      @file_wrapper = file_wrapper
    end

    def load
      @data = @file_wrapper.read_data
    end
  end
end
