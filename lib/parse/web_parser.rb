require 'mechanize'
require 'uri'
# require 'curb'

class WebParser
  def initialize
    @agent = Mechanize.new
    @result = {}
  end

  def parser_petsonic(url)
    @uri = URI url
    page = @agent.get @uri
    url_all = page.forms[5].submit
    page_all = @agent.get url_all.uri
    links_all = page_all.search('//a[@class="product_img_link"]')
    counter = 0
    links_all.each do |link|
      img_link = link.search('img[@class="replace-2x img-responsive"]/@src').text
      @result[link['href']] = { "img" => img_link }
    end
    href_arr = @result.keys.shuffle
    puts "#{href_arr.size}: total links"
    href_arr.each do |link|
      counter += 1
      puts "#{counter}: processing"
      sleep(rand(5))
      fetch_link = @agent.get link
      full_name = []
      basis_name = fetch_link.search('//div[@class="product-name"]').search('.nombre_producto').text
      basis_name = basis_name.gsub(/\n\n/, '*').delete("\n").strip.split('*').last.delete('"').strip
      fetch_link.search('//span[@class="attribute_name"]').each do |n|
        full_name << "#{basis_name} #{n.text}"
      end
      arr_tmp = []
      fetch_link.search('//span[@class="attribute_price"]').each_with_index do |price, i|
        st = price.text.delete("\n").delete("\t").strip
        nm = full_name[i]
        arr_tmp << [nm, st]
        @result[link].merge!("atr" => arr_tmp)
      end
      next unless full_name.empty?
      nm =  basis_name.to_s
      st =  fetch_link.search('//span[@id="our_price_display"]').text
      arr_tmp << [nm, st]
      @result[link].merge!("atr" => arr_tmp)
      #       require 'pry'; binding.pry
    end
    @result
  end
end
