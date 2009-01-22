module Gisting
  class ReduceRunner

    attr_accessor :map_data_input, :red_proc

    def initialize(intermediate_file, proc, output)
      @histogram = {}
      @red_proc = proc
      @output_file = output
      @map_data_input = intermediate_file
      setup_emit
      pp ["red_runner", @map_data_input, @red_proc, @output_file]
    end

    def Emit(count)
      if @histogram[@key].nil?
        @histogram[@key] = count
      else
        @histogram[@key] += count
      end
    end

    def reduce!
      begin
        File.open(@map_data_input).each do |line|
          @key, val = line.strip.split(":")
          apply([val.strip])
        end
        reduce_completed!
      rescue => e
        puts $!
        e.backtrace.each {|x| puts x}
      end
    end
    
    def output
      @output_file
    end
    
    protected
    
    def apply(data_item)
      @proc ||= eval(@red_proc)
      @proc.call(data_item)
    end

    def setup_emit
      # puts "setting up emit"
      if File.exists?(@output_file)
        # puts "#{@output_file} exists... loading into memory"
        File.open(@output_file).each do |line|
          @key, val = line.strip.split(":")
          apply([val.strip])
        end
      else
        # puts "#{@output_file} does not exist.. creating for first time"
        FileUtils.touch(@output_file)
      end
    end

    def reduce_completed!
    	out = Tempfile.new("tempfile")
      # pp out.path
      @histogram.each_pair do |key, val|
        out.puts("#{key}: #{val}")
      end
      out.close
    	FileUtils.mv(out.path, @output_file)
    end

  end
end