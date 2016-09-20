require 'json'
module TimeLogger
  class FileWrapper

    # file close in #write_data and #read_data?

    def close_file(file)
      file.close
    end

    def write_data(file_name, data_hash)
      File.open(file_name, "w") do |file|
        file.write(JSON.pretty_generate(data_hash))
      end
    end

    def read_data(file_name)
      file_read = File.read(file_name)
      JSON.parse(file_read)
    end
  end
end
