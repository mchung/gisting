# Runs the Gisting spec.

# TODO Limitation: MapClients == ReduceClients.

module Gisting
  class Spec

    attr_reader :map_inputs

    def initialize
      @map_inputs = []
    end

    def add_input
      input = Input.new
      @map_inputs << input
      input
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

    def stop!
      EM::stop_event_loop
    end

    # TODO Round-robin assign available servers with jobs. Need to map M jobs to N servers
    def run_map!(result)
      EM::run do
        # One for every map input
        EM::connect "127.0.0.1", 9081, Gisting::MapClient, @map_inputs[0], result
        EM::connect "127.0.0.1", 9082, Gisting::MapClient, @map_inputs[1], result
        # EM::connect "127.0.0.1", 9083, Gisting::MapClient, @map_inputs[2], result
      end
    end

    # TODO Round-robin assign available servers with job. Need to map M jobs to N servers
    def run_reduce!(result)
      reduce = result.setup_reduce_stage(@map_output)
      EM::run do 
        # One for every output#num_task
        EM::connect "127.0.0.1", 9091, Gisting::ReduceClient, reduce[0], result
        # EM::connect "127.0.0.1", 9092, Gisting::ReduceClient, reduce[1], result
      end
    end

  end
end