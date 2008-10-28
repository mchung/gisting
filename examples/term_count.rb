lib_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'gisting'

# TODO: Grab this from ARGV
def args
  args = ["/Users/mchung/Public/datasets/sample.data", "/Users/mchung/Public/datasets/sample.data"]
  # args = ["/Users/mchung/Public/datasets/sample.data", "/Users/mchung/Public/datasets/sample.data", "/Users/mchung/Public/datasets/sample.data"]
  # args = ["/Users/mchung/Public/datasets/aoldb_dev.txt", "/Users/mchung/Public/datasets/aoldb_dev.txt"]
  # args = ["/Users/mchung/Public/datasets/sample.data", "/Users/mchung/Public/datasets/aoldb_dev.txt"]
  args
end

if __FILE__ == $0
  inputs = args
  spec = Gisting::Spec.new
  inputs.each do |file_input|
    input = spec.add_input
    input.file_pattern = file_input
    input.map do |map_input|
      # 2722	mailbox	2006-05-23 00:08:39
      words = map_input.strip.split("\t")
      Emit(words[1], "1")
    end
  end
  output = spec.output
  output.filebase = "/Users/mchung/Public/datasets/output"
  output.num_tasks = 1
  output.reduce do |reduce_input|
    count = 0
    reduce_input.each do |value|
      count += value.to_i
    end
    Emit(count)
  end

  # TODO Shouldn't need to pass the spec into the result
  result = Gisting::Result.new(spec)
  # TODO This is so the spec knows where to find the map and reduce servers
  # spec.setup_wth_paths_to_servers
  spec.run_map!(result)
  spec.run_reduce!(result)
end
