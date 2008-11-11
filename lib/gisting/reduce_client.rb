module Gisting

  module ReduceClient

    def initialize(job)
      super # Required by EventMachine
      @job = job
    end

    def post_init
      @output, @proc = @job.next_reduce_job
      send_next_intermediate_job
    end

    def receive_data(output_result)
      @job.reduce_client_recv!(@file_pattern, output_result)
      send_next_intermediate_job
    end

    def send_next_intermediate_job
      @file_pattern, intermediate_job = @job.next_intermediate_job
      if @file_pattern && intermediate_job
        send_data([intermediate_job, @proc, @output].to_yaml)
        @job.reduce_client_sent!(@file_pattern)
      end
    end

  end
end
