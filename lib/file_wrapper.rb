require 'json'
module TimeLogger
  class FileWrapper


    def write_data(file_name, data_hash)
      File.open(file_name, "w") do |file|
        file.write(JSON.pretty_generate(data_hash))
      end
    end

    def read_data(file_name)
      data_file = File.read(file_name)
      JSON.parse(data_file)
    end
  end
end
