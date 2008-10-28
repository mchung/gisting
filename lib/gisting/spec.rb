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

    # TODO Round-robin assign available servers with jobs
    def run_map!(result)
      EM::run do
        # One for every map input
        EM::connect "127.0.0.1", 9081, Gisting::MapClient, @map_inputs[0], result
        EM::connect "127.0.0.1", 9082, Gisting::MapClient, @map_inputs[1], result
        # EM::connect "127.0.0.1", 9083, Gisting::MapClient, @map_inputs[2], result
      end
    end

    # TODO Round-robin assign available servers with job
    def run_reduce!(result)
      reduce = result.setup_reduce_stage(@map_output)
      EM::run do
        # One for every output#num_task
        EM::connect "127.0.0.1", 9091, Gisting::ReduceClient, reduce[0], result
        # EM::connect "127.0.0.1", 9092, Gisting::ReduceClient, reduce[1], result
      end
    end

    ## should have a spec.output_task which when called, marks the object for queue and sends it to the reduce server.
    ## reduce conductor should keep doing this until we're done with the data sets

    # Reduce should initiate a call for every num_task there is, and creating a file name that's predictable based on filebase
    # Should also modify "result" object to sync against the connects. for instance, creating the files from the filebase, but for each map file, dispatch against them. then unblock in similar fashion
    # Should be able to dispatch multiple Reduce tasks round robin to only a fixed number of machines
    # probably need a reduce conductor.. delgates calls to reduceserver. uses results to share items across #connects


  end
end