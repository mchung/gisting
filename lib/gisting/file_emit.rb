module Gisting

  # Emits output to a file
  class FileEmit

    def initialize(file_output)
      # pp file_output
      @output = file_output
      @buffer = 0
    end

    def store(key, value)
      string = "#{key}: #{value}"
      # pp [key, value]
      @output.puts(string)
      @buffer += string.size
    end

    protected

    def flush_if_necessary
      if @buffer > 2048
        @output.flush
        @buffer = 0
      end
    end

  end
end