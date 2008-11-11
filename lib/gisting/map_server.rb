# A MapServer processes map input tasks

module Gisting
  module MapServer

    def post_init
      puts "MapServer Starting..."
    end

    def receive_data(job)
      begin
        puts "Running MapRunner"
        file_pattern, proc = YAML.load(job)
        runner = MapRunner.new(file_pattern, proc)

        thread = Proc.new { runner.map! }
        callback = Proc.new { send_data(runner.output) }
        EM.defer(thread, callback)
      rescue => e
        pp [:map_server, e]
      end
    end

  end
end
