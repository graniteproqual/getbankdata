 require 'rake/testtask'
 require 'rdoc/task'

 RDoc::Task.new do |rdoc|
   rdoc.main = "README.rdoc"
   rdoc.rdoc_files.include("README.rdoc", "lib   /*.rb")
 end

 Rake::TestTask.new do |task|
   task.libs << %w(test lib)
   task.pattern = 'test/*_test.rb'
 end

 task :default => :test