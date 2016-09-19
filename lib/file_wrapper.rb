module TimeLogger
  class FileWrapper

    def open_read_file(file_name)
      File.open(file_name, "r")
    end

    def open_write_file(file_name)
      File.open(file_name, "w")
    end

    def close_file(file)
      file.close
    end

    def write_data(open_file, data_hash)
      open_file do |file|
        file.write(data_hash.to_json)
      end
    end

    def read_data(open_file)
      JSON.parse(open_file)
    end
  end
end
