module Gisting
  class ReduceRunner

    attr_accessor :map_data_input, :red_proc

    def initialize(output, input)
      @map_data_input = input
      @histogram = {}
      @red_proc = output.reduce_proc
      @output_file = output.filebase
      setup_emit
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
        puts "reducing"
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
      if File.exists?(@output_file)
        File.open(@output_file).each do |line|
          key, val = line.strip.split(":")
          @histogram[key] = val
        end
      else
        FileUtils.touch(@output_file)
      end
    end

    def reduce_completed!
    	out = Tempfile.new("tempfile")
    	pp out.path
      @histogram.each_pair do |key, val|
        out.puts("#{key}: #{val}")
      end
      out.close
    	FileUtils.mv(out.path, @output_file)
    end

    # attr_accessor :data_source, :map_proc
    # attr_reader :output
    # 
    # def initialize(map_input)
    #   pp map_input
    #   @data_source = map_input.file_pattern
    #   @map_proc = map_input.map_proc
    #   setup_emit
    # end
    # 
    # def Emit(key, value)
    #   @emit.store(key, value)
    # end
    # 
    # def map!
    #   # TODO Abstract away file data source
    #   File.read(self.data_source).each do |line|
    #     apply(line)
    #   end
    #   map_completed!
    # end
    # 
    # def output
    #   @intermediate_output
    # end
    # 
    # protected
    # 
    # def apply(data_item)
    #   # pp data_item
    #   @proc ||= eval(self.map_proc)
    #   @proc.call(data_item)
    # end
    # 
    # def setup_emit
    #   # TODO Abstract away file data source
    #   @intermediate_output = make_intermediate_output
    #   @output = File.new(@intermediate_output, "w")
    #   @emit = FileEmit.new(@output)
    # end
    # 
    # def make_intermediate_output
    #   # TODO Abstract away file data source
    #   basedir = File.dirname(@data_source)
    #   filename = File.basename(@data_source)
    #   old_ext = File.extname(filename)
    #   filename_no_ext = File.basename(filename, old_ext)
    #   new_ext = rand(100).to_s
    #   intermediate_filename = "#{filename_no_ext}.#{new_ext}#{old_ext}"
    #   
    #   File.join(basedir, "results", intermediate_filename)
    # end
    # 
    # def map_completed!
    #   # TODO Abstract away file data source
    #   @output.flush
    #   @output.close
    # end

    # def giest_old(spec, result)
    # 
    #   # Map. two data sources.
    #   EM::run {
    #     EM::connect "127.0.0.1", 8081, Gisting::Conductor, spec.map_inputs[0], result
    #     EM::connect "127.0.0.1", 8082, Gisting::Conductor, spec.map_inputs[1], result
    #   }
    # 
    #   # Reduce is hacked for now.
    #   # pp result
    # 
    #   data = String.new
    #   result.responses.each do |file|
    #     data += File.read(file)
    #   end
    #   # puts data
    # 
    #   # data = data.sort{|a, b| a <=> b} # need to sort?
    #   
    #   # red_proc ||= eval(spec.output.reduce_proc)
    #   # data.each do |key|
    #   #   key, val = key.strip.split(":")
    #   #   @key = key
    #   #   red_proc.call(val)
    #   # end
    #   # print_term_freq(@histogram)
    # 
    #   term_count(data)
    # 
    # 
    # end

  end
end