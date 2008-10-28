module Gisting
  class Result

    def initialize(spec)
      @map_responses = []
      @reduce_responses = []

      # TODO this is stupid. should specs and results be coupled like this?
      @spec = spec 

      @sent_count = 0
      @index = 0
      @lock = Mutex.new
    end

    def recv_map_data!(recv_data)
      @map_responses << recv_data
      if @map_responses.size == @spec.map_input_count
        puts "Stopping Map phase"
        @spec.stop!
      else
        puts "Got Map result #{recv_data}. #{@spec.map_input_count - @map_responses.size} remaining."
      end
    end

    def sent_map_data!
      @sent_count += 1
      if @sent_count == @spec.map_input_count
        puts "Maps distributed"
      # else
      #   puts "More maps to distribute"
      end
    end

    def recv_reduce_data!(output_result)
      @reduce_responses << output_result
      if @reduce_responses.size == @spec.map_input_count
        puts "Stopping Reduce phase"
        @spec.stop!
      else
        puts "Got Reduce result data #{output_result}. #{@spec.map_input_count - @reduce_responses.size} remaining."
      end
    end

    def sent_reduce_data!
      puts "Sent reduce data"
    end
    
    def setup_reduce_stage(output)
      if @reduce_tasks.nil?
        @reduce_tasks = []
        1.upto(output.num_tasks) do |idx|
          @reduce_tasks << output.clone
          @reduce_tasks.last.filebase = "#{output.filebase}_#{idx}"
        end
      end
      @reduce_tasks
    end

    # Called by different threads
    def next_available_map_result
      @lock.synchronize {
        input = @map_responses[@index]
        @index += 1
        input
      }
    end

  end
end