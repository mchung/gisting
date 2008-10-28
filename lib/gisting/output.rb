module Gisting
  class Output

    attr_accessor :filebase
    attr_accessor :num_tasks
    attr_reader :reduce_proc

    def reduce(&block)
      @reduce_proc = block.to_ruby
    end

  end
end