# A MapWorker processes map input tasks

module Gisting
  module MapServer

    def post_init
      puts "MapServer Starting..."
    end

    # Delegates a +map input+ task to a MapRunner and returns 
    # (via +send_data+) the name of the intermediate file
    def receive_data(input_data)
      proc = Proc.new do 
        puts "Running MapRunner"
        input = YAML::load(input_data)
        runner = MapRunner.new(input)
        runner.map!
        send_data(runner.output)
      end
      EM.defer(proc)
    end

  end
end
