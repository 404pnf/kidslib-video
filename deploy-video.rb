def deploy
  puts "同步到服务器了" if system('rsync -avz output/* wxkj:/var/www/ilearning/video/')
end


