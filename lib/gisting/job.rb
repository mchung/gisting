module Gisting

  # A Job tracks the details of a Gisting MapReduce run.  It is thread-
  # safe resource shared by MapClient and ReduceClient instances.
  class Job

    def initialize(job_progress)
      @job_progress = job_progress
      @lock = Mutex.new
    end

    # Public methods are protected by a Mutex

    def map_client_sent!(file_pattern)
      @lock.synchronize do
        @job_progress.start_map_job(file_pattern)
        puts "MapServer processing #{file_pattern}"
        puts "All Map Jobs Distributed" if @job_progress.all_map_jobs_in_progress?
      end
    end

    def map_client_recv!(file_pattern, intermediate_job)
      @lock.synchronize do
        @job_progress.stop_map_job(file_pattern, intermediate_job)
        if @job_progress.all_map_jobs_completed?
          stop!
        end
      end
    end

    def next_map_job
      @lock.synchronize do
        @job_progress.next_map_job
      end
    end

    def next_reduce_job
      @lock.synchronize do
        @job_progress.next_reduce_job
      end
    end

    def next_intermediate_job
      @lock.synchronize do
        @job_progress.next_intermediate_job
      end
    end

    def reduce_client_sent!(file_pattern)
      @lock.synchronize do
        @job_progress.start_reduce_job(file_pattern)
        puts "ReduceServer processing #{file_pattern}"
        puts "All Reduce Jobs Distributed" if @job_progress.all_reduce_jobs_in_progress?
      end
    end

    def reduce_client_recv!(file_pattern, output_result)
      @lock.synchronize do
        @job_progress.stop_reduce_job(file_pattern, output_result)
        if @job_progress.all_reduce_jobs_completed?
          stop!
        end
      end
    end

    # This smells funny
    def stop!
      # Stop all client connections and ends the reactor in Cluster
      EM::stop_event_loop
    end

  end

end
