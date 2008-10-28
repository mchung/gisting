# A ReduceClient sends Output tasks to ReduceServers

module Gisting

  module ReduceClient

    def initialize(*args)
      super
      puts "Running Reduce Client"
      @output = args[0]
      @result = args[1]
      raise Error if bad_job?
    end

    def post_init
      send_task_if_available
    end

    def receive_data(output_result)
      recv_task(output_result)
      send_task_if_available
    end

    protected


    def send_task_if_available
      next_task = @result.next_available_map_result
      if next_task
        send_data([@output, next_task].to_yaml)
        @result.sent_reduce_data!
      end
    end

    def recv_task(output_result)
      @result.recv_reduce_data!(output_result)
    end

    # TODO ReduceClient#bad_job? detects badly created output tasks
    def bad_job?
      false
    end

  end
end
