module Gisting
  class Input

    attr_accessor :file_pattern
    attr_reader :map_proc

    def map(&block)
      @map_proc = block.to_ruby
    end

  end
end