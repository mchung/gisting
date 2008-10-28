# A MapClient sends an Input to a MapServer

module Gisting

  module MapClient

    def initialize(*args)
      super
      @input = args[0]
      @result = args[1]
      raise Error if bad_job?
    end

    def post_init
      send_data(@input.to_yaml)
      @result.sent_map_data!
    end

    def receive_data(output_data)
      @result.recv_map_data!(output_data)
    end

    protected

    # TODO MapClient#bad_job? detects badly created input tasks
    def bad_job?
      false
    end

  end
end
