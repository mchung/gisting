module Gisting

  # A JobProgress keeps track of a running Gisting instance
  class JobProgress

    def initialize
      @map_jobs = {} # Key is the name of the file_pattern. Value = {}
      @red_jobs = {} # Key is the name of the output file, Value = proc

      @jobs_map_started = 0
      @jobs_map_completed = 0
      @jobs_reduce_started = 0
      @jobs_reduce_completed = 0
      @next_map_job, @next_intermediate_job, @next_reduce_job = 0, 0, 0 # Counters
    end

    def init_map_job(input)
      @map_jobs[input.file_pattern] = {:proc => input.map_proc}
    end

    def init_reduce_job(output, reduce_proc)
      @red_jobs[output] = reduce_proc
    end

    def start_map_job(file_pattern)
      @map_jobs[file_pattern][:map_started_at] = Time.now
      @jobs_map_started +=1
    end

    def stop_map_job(file_pattern, intermediate_job)
      @map_jobs[file_pattern][:map_ended_at] = Time.now
      @map_jobs[file_pattern][:intermediate_job] = intermediate_job
      @jobs_map_completed += 1
    end

    def start_reduce_job(file_pattern)
      @map_jobs[file_pattern][:reduce_started_at] = Time.now
      @jobs_reduce_started += 1
    end

    def stop_reduce_job(file_pattern, output_result)
      @map_jobs[file_pattern][:reduce_ended_at] = Time.now
      @map_jobs[file_pattern][:output_base] = output_result
      @jobs_reduce_completed += 1
    end

    # TODO Does to_a do consistent ordering?
    # @map_jobs_arr ||= @map_jobs.to_a

    # Returns the file_pattern and the Map proc
    def next_map_job
      if @next_map_job < @map_jobs.to_a.size
        job = @map_jobs.to_a[@next_map_job]
        @next_map_job += 1
        file_pattern = job[0]
        proc = job[1][:proc]
        return file_pattern, proc
      end
    end

    # Returns the file_pattern and the intermediate output
    def next_intermediate_job
      if @next_intermediate_job < @map_jobs.to_a.size
        job = @map_jobs.to_a[@next_intermediate_job]
        @next_intermediate_job += 1
        file_pattern = job[0]
        intermediate_job = job[1][:intermediate_job]
        return file_pattern, intermediate_job
      end
    end

    # Returns the output_result and the Reduce proc
    def next_reduce_job
      if @next_reduce_job < @red_jobs.to_a.size
        job = @red_jobs.to_a[@next_reduce_job]
        @next_reduce_job += 1
        output_result = job[0]
        proc = job[1]
        return output_result, proc
      end
    end

    def all_map_jobs_in_progress?
      @jobs_map_started == @map_jobs.size
    end

    def all_map_jobs_completed?
      @jobs_map_completed == @map_jobs.size
    end

    def remaining_map_jobs
      @jobs_map_started - @jobs_map_completed
    end

    def all_reduce_jobs_in_progress?
      @jobs_reduce_started == @map_jobs.size
    end

    def all_reduce_jobs_completed?
      @jobs_reduce_completed == @map_jobs.size
    end

    def remaining_reduce_jobs
      @jobs_reduce_started - @jobs_reduce_completed
    end

  end
end