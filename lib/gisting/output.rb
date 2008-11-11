module Gisting
  
  # An Output is the path to the output file, the number of reduce tasks to
  # run (the number of files in the format: filebase_1, filebase_2, etc) and
  # the Reduce proc.
  class Output

    attr_accessor :filebase
    attr_accessor :num_tasks
    attr_reader :reduce_proc

    def reduce(&block)
      @reduce_proc = block.to_ruby
    end

  end

end