# A ReduceServer processes reduce output tasks

module Gisting
  module ReduceServer

    def post_init
      puts "ReduceServer Starting..."
    end

    # Delegates an +map output+ task to a ReduceRunner and returns 
    # (via +send_data+) the name of the intermediate file
    def receive_data(job)
      begin
        puts "Running ReduceRunner"
        intermediate_file, proc, output = YAML.load(job)
        runner = ReduceRunner.new(intermediate_file, proc, output)

        thread = Proc.new { runner.reduce! }
        callback = Proc.new { send_data(runner.output) }
        EM.defer(thread, callback)
      rescue => e
        pp [:red_server, e]
      end
    end

  end
end
