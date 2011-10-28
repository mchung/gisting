# A MapServer processes map input tasks

module Gisting
  module MapServer

    def post_init
      puts "MapServer Starting..."
    end

    # Executes a MapRunner with a file pattern
    def receive_data(job)
      begin
        puts "Running MapRunner"
        file_pattern, proc = YAML.load(job)
        runner = MapRunner.new(file_pattern, proc)

        thread = Proc.new { runner.map! }
        callback = Proc.new { send_reply(runner.output) }
        EM.defer(thread, callback)
      rescue => e
        pp [:map_server, e]
      end
    end

    def send_reply(output)
      send_data(output)
      puts "Completed MapRunner"
    end

  end
end
