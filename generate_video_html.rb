require 'csv'
require 'erubis'

def generate_video_html(path)
	CSV.read(path).each do |id, title, *_|
    page_title = title
    flv_url = "flv/#{ id.strip }.flv"

    input = File.read('index.eruby')
    eruby = Erubis::Eruby.new(input)    # create Eruby object
    index_html =  eruby.result(binding) # get result

    p "生成 #{ id }.html "
    File.write("output/#{ id }.html", index_html)
  end
end

if __FILE__ == $PROGRAM_NAME
  path = ARGV[0]
  p "输入文件是#{ path }"
  generate_video_html(path)
end
