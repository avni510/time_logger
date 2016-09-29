module TimeLogger
  class FileWrapper
    
    def initialize(file_name)
      @file_name = file_name
    end

    def write_data(data_hash)
      File.open(@file_name, "w") do |file|
        file.write(JSON.pretty_generate(data_hash))
      end
    end

    def read_data
      data_file = File.read(@file_name)
      JSON.parse(data_file)
    end
  end
end
