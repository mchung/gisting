module Gisting
  module MapClient

    def initialize(job)
      super # Required by EventMachine
      @job = job
    end

    def post_init
      send_map_job
    end

    def receive_data(intermediate_job)
      @job.map_client_recv!(@file_pattern, intermediate_job)
    end

    def send_map_job
      @file_pattern, proc = @job.next_map_job
      if @file_pattern && proc
        send_data([@file_pattern, proc].to_yaml)
        @job.map_client_sent!(@file_pattern)
      end
    end

  end
end
