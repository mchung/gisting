# A ReduceServer processes reduce output tasks

module Gisting
  module ReduceServer

    def post_init
      puts "ReduceServer Starting..."
    end

    # Executes a ReduceRunner with an intermediate file
    def receive_data(job)
      begin
        puts "Running ReduceRunner"
        intermediate_file, proc, output = YAML.load(job)
        runner = ReduceRunner.new(intermediate_file, proc, output)

        thread = Proc.new { runner.reduce! }
        callback = Proc.new { send_reply(runner.output) }
        EM.defer(thread, callback)
      rescue => e
        pp [:red_server, e]
      end
    end
    
    def send_reply(output)
      send_data(output)
      puts "Completed ReduceRunner"
    end

  end
end
