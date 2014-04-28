require 'open-uri'
require 'nokogiri'
require 'fileutils'

URL = 'http://imgsrc.ru/main/pic_tape.php?ad=%d&way=desc&pwd=&skp=%d'

ad = 464733
url = 'http://imgsrc.ru/jasper1123/15860055.html#bp'
output = File.expand_path('~/Desktop/test')

def download_page(ad, output, skip)

  FileUtils.mkdir_p(output)

  url = URL % [ad, skip]
  doc = Nokogiri::HTML(open(url).read)

  count = 0

  doc.css('img.big').each_with_index do |img, i|
    real_i = i + skip
    real_i_string = '%04d' % real_i

    puts 'Downloading image ' + real_i_string
    count += 1

    output_filename = File.join(output, "#{real_i_string}.jpg")
    src = img['src']

    File.write(output_filename, open(src).read)
  end

  return count

end

0.upto(10000) do |page|
  count = download_page(ad, output, 12 * page)

  break if count == 0
end