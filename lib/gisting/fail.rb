# Internal errors
module Gisting

  #
  class BusyClusterFail < Exception

    #
    def initialize(spec)
      super
      @spec = spec
    end

    def message
      # Job required #{@spec.map_inputs.size} MapServers and #{@spec.output.num_tasks} ReduceServers.
      "Not enough machines available to run job. Requested #{@spec.map_inputs.size} MapServers and #{@spec.output.num_tasks} ReduceServers"
    end

  end

end