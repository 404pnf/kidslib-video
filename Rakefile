require_relative 'generate_video_html.rb'

# ## a timer
def time(&block)
  t = Time.now
  result = block.call
  puts "\nCompleted in #{(Time.now - t)} seconds\n\n"
  result
end

desc "help msg"
task :help do
  puts 'rake gen:  生成html'
  puts 'rake deploy:  部署html和静态文件到服务器'
  puts 'rake all:  相当于先rake gen再rake deploy'
  puts 'rake -T:  查看所有任务'
end

desc "generate html"
task :gen do
  time { video }
end

desc "deploy"
task :deploy do
  system("rsync -avz output/* wxkj:/var/www/ilearning/video/")
  puts "\n\n同步到服务器了"
end

desc "generate and deploy"
task :all => [:gen, :deploy] do
  puts "\nRake: 生成html并部署到服务器了。"
end

task :default => [:help]
