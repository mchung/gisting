module Gisting

  # A Spec contains multiple Inputs and a single Output
  class Spec

    def initialize
      @map_inputs = []
    end

    def add_input
      input = Input.new
      @map_inputs << input
      input
    end

    def map_inputs
      @map_inputs
    end

    def output
      @map_output ||= Output.new
    end

    def map_input_count
      @map_inputs.size
    end

    def reduce_output_count
      @map_output.num_tasks
    end

  end
end