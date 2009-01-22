module Gisting
  module MapReduce

    # Run a MapReduce job
    def map_reduce(spec)
      map_servers = find_available_map_servers(spec.map_input_count)
      red_servers = find_available_reduce_servers(spec.reduce_output_count)
      raise BusyClusterFail.new(spec) unless map_servers && red_servers
      cluster = Cluster.new(map_servers, red_servers)
      job = Job.new(setup(spec))
      cluster.map(job)
      cluster.reduce(job)
      Result.new(job)
    rescue BusyClusterFail => e
      puts e.message
    rescue Exception => e
      puts "Caught exception..."
      puts e.message
      # job.stop!
    end

    alias :MapReduce :map_reduce

    def setup(spec)
      returning (JobProgress.new) do |job|
        spec.map_inputs.each do |input|
          job.init_map_job(input)
        end
        1.upto(spec.output.num_tasks) do |i|
          job.init_reduce_job("#{spec.output.filebase}_#{i}", spec.output.reduce_proc)
        end
      end
    end

    # TODO: Today, these are hard coded values. Tomorrow they will be dynamically found and assigned
    def find_available_map_servers(count)
      case count
      when 1
        [["127.0.0.1", 9081]]
      when 2
        [["127.0.0.1", 9082], ["127.0.0.1", 9083]]
      when 3
        [["127.0.0.1", 9081], ["127.0.0.1", 9082], ["127.0.0.1", 9083]]
      when 4
        [["127.0.0.1", 9081], ["127.0.0.1", 9082], ["127.0.0.1", 9083], ["127.0.0.1", 9084]]
      when 5
        [["127.0.0.1", 9081], ["127.0.0.1", 9082], ["127.0.0.1", 9083], ["127.0.0.1", 9084], ["127.0.0.1", 9085]]
      else
        nil
      end
    end

    # TODO: Today, these are hard coded values. Tomorrow they will be dynamically assigned
    def find_available_reduce_servers(count)
      case count
      when 1
        [["127.0.0.1", 9091]]
      when 2
        [["127.0.0.1", 9091], ["127.0.0.1", 9092]]
      else
        nil
      end
    end

  end
end