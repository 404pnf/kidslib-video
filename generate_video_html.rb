# ## 使用方法
#
# 1. 输入的csv文件写死在脚本中了。为了能够方便使用rake生成部署
# 2. rake 查看可执行任务
#
#
# ## 用途
# 从csv每条记录生成对应的html
#
# ----

# ## 需要库
# 不再用erubis了。因为erb是ruby标准库的。
# 为了方便让有ruby但没有gem的环境使用，尽量都使用标准库中的东西。
require 'csv'
require 'erb'
require 'fileutils'
require 'erubis'

# ## CSV格式
# 请确保csv文件的header与下面一一对应！
#
#       "title","video","category","age"
#       "穿鞋真舒服"," hb12_music_01","欢乐音乐屋","1-3岁"
#
# 只要把video添加.flv后缀就是视频文件的文件名
#
# ----

# ## 主程序
# 我们需要为erubis tpl准备3个变量。
#
#       id, page_title, flv_url
# 对应csv中的
#       video, title, video+'.flv'
# ----
def generate_video_html(path)
  CSV.table(path, converters: nil).each do |csv|
    id, page_title, flv_url = csv[:video].strip, csv[:title].strip, "../flv/#{csv[:video].strip}.flv"
    #context = {id: id, page_titile: page_title, flv_url: flv_url}
    index_html = Erubis::Eruby.new(File.read('views/index.eruby')).result(binding)
    #index_html = ERB.new(File.read('views/index.eruby')).result(binding)
    p "生成 #{ id }.html "
    File.write("output/html/#{ id }.html", index_html)
  end
end

# views目录后的点 '.' 表示复制该目录下所有内容，但不创建该目录
def copy_asset_to_output
  FileUtils.cp_r 'views/.', 'output', :verbose => true
end

# ## 干活
def video
  path = 'csv/all-video.csv'
  puts "\n输入文件是#{ path }"
  generate_video_html(path)
  copy_asset_to_output
end