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
# erubis中的@var 名就是csv的headers
#
# ----

class Video
  def initialize(file)
    @h = CSV.table(file, converters: nil).map(&:to_hash)
  end

  def each_video
    @h.each do |e| 
      yield e.each_with_object({}) { |(k, v), o| o[k] = v.strip } 
    end
  end
end

def bind(tpl)
  lambda { |context| Erubis::Eruby.new(File.read(tpl)).evaluate(context) }
end

# views目录后的点 '.' 表示复制该目录下所有内容，但不创建该目录
def copy_asset_to_output
  FileUtils.cp_r 'views/.', 'output', :verbose => true
end

# ## main
def video
  v = Video.new 'csv/all-video.csv'
  tpl = bind 'views/index.eruby'
  v.each_video do |e| 
    html = tpl.call e
    p "write #{ e[:video] } "
    File.write("_newoutput/html/#{ e[:video] }.html", html)
  end
  copy_asset_to_output
end

