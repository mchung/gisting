module Gisting
  
  # The runner emits the results of the proc applies to each item in the data source.
  class MapRunner

    attr_accessor :data_source, :map_proc

    def initialize(file_pattern, proc)
      @data_source = file_pattern
      @map_proc = proc
      setup_emit
    end

    def Emit(key, value)
      @emit.store(key, value)
    end

    def map!
      # TODO Abstract away file data source
      File.read(self.data_source).each do |line|
        apply(line)
      end
      map_completed!
    end

    def output
      @intermediate_output
    end

    protected

    def apply(data_item)
      # pp data_item
      @proc ||= eval(self.map_proc)
      @proc.call(data_item)
    end

    def setup_emit
      # TODO Abstract away file data source
      @intermediate_output = make_intermediate_output
      @output = File.new(@intermediate_output, "w")
      @emit = FileEmit.new(@output)
    end
    
    def make_intermediate_output
      # TODO Abstract away file data source
      basedir = File.dirname(@data_source)
      filename = File.basename(@data_source)
      old_ext = File.extname(filename)
      filename_no_ext = File.basename(filename, old_ext)
      new_ext = rand(100).to_s
      intermediate_filename = "#{filename_no_ext}.#{new_ext}#{old_ext}"
      
      File.join(basedir, "results", intermediate_filename)
    end

    def map_completed!
      # TODO Abstract away file data source
      @output.flush
      @output.close
    end

  end
end