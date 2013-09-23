require 'csv'
require 'erubis'
require 'FileUtils'

def generate_video_html(path)
	CSV.read(path).each do |id, title, *_|
    id.strip! # 有些id的文本前面有空白！
    page_title = title
    flv_url = "flv/#{ id }.flv"

    input = File.read('views/index.eruby')
    eruby = Erubis::Eruby.new(input)    # create Eruby object
    index_html =  eruby.result(binding) # get result

    p "生成 #{ id }.html "
    File.write("output/#{ id }.html", index_html)
  end
end

def copy_asset_to_output
  # If you want to copy all contents of a directory instead of the
  # directory itself, c.f. src/x -> dest/x, src/y -> dest/y,
  # use following code.
  # cp_r('src', 'dest') makes dest/src,
  # but this doesn't.
  FileUtils.cp_r 'views/.', 'output', :verbose => true
end

if __FILE__ == $PROGRAM_NAME
  path = ARGV[0] || 'csv/all_vid.csv'
  p "输入文件是#{ path }"
  generate_video_html(path)
  copy_asset_to_output
end
