require 'rake'
require 'spec/rake/spectask'

task :default => [:spec]

desc "Run Gist specs"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ["-fs", "-c"]
  t.spec_files = FileList['spec/**/*.rb']
end
