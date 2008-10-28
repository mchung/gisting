# A ReduceServer processes reduce output tasks

module Gisting
  module ReduceServer

    def post_init
      puts "ReduceServer Starting..."
    end

    # Delegates an +map output+ task to a ReduceRunner and returns 
    # (via +send_data+) the name of the intermediate file
    def receive_data(output_data)
      proc = Proc.new do 
        puts "Running ReduceRunner"
        # begin
        output, input = YAML::load(output_data)
        runner = ReduceRunner.new(output, input)
        runner.reduce!
        # pp ["output", runner.output]
        send_data(runner.output)
        # rescue  => e
        #   e.backtrace.each do |x|
        #     puts x
        #   end
        # end
      end
      EM.defer(proc)
    end

  end
end
