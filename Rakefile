require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false # for thrift
end

task default: :test

task :generate do
  require "tmpdir"

  Dir.chdir(Dir.mktmpdir) do
    system "thrift", "-r", "--gen", "rb", File.expand_path("thrift/TCLIService.thrift", __dir__), exception: true

    Dir["gen-rb/*"].each do |file|
      dest = File.expand_path("lib/hexspace/#{File.basename(file)}", __dir__).sub("t_c_l_i", "tcli")
      lines = File.readlines(file).reject { |l| l.start_with?("require ") }
      File.write(dest, lines.join)
    end
  end
end
