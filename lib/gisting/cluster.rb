module Gisting

  # A Cluster manages connections to MapServers and ReduceServers
  class Cluster

    #
    def initialize(map_servers, reduce_servers)
      @map_servers = map_servers
      @red_servers = reduce_servers
    end

    #
    def map(job)
      EM::run do
        @map_servers.each_with_index do |machine, idx|
          host, port = machine[0], machine[1]
          puts "Connecting to MapServer on #{host}:#{port}"
          EM::connect host, port, MapClient, job
        end
      end
    end

    #
    def reduce(job)
      EM::run do
        @red_servers.each_with_index do |machine, idx|
          host, port = machine[0], machine[1]
          puts "Connecting to ReduceServer on #{host}:#{port}"
          EM::connect host, port, ReduceClient, job
        end
      end
    end

  end

end