require 'mechanize'
require 'sinatra/activerecord'
require './models/category'
require './models/item'

FLYERS = {
  "No Frills" => "http://www.nofrills.ca/LCLOnline/flyers_landing_page.jsp?flyerView=item&storeId=336",
#  "Superstore" => "http://www.superstore.ca/LCLOnline/flyers_landing_page.jsp?flyerView=item&storeId=373"
}

desc "Sync flyer data"
task :sync_flyers do
  Category.delete_all
  Item.delete_all

  m = Mechanize.new
  flyer_data = {}
  FLYERS.each do |store_name, url|
    puts "Downloading flyer for #{store_name}..."
    p = m.get(url)

    # find category links
    p.links_with(:href => /categoryId/).each do |link|
      category_name = link.text.strip
      category_page = link.click
      flyer_data[category_name] = Category.create(:name => category_name) unless flyer_data.keys.include? category_name

      category_page.search('div.searchResultsGridItem').each do |item|
        price = item.search('p.productPrice').text.gsub(/[\r\n\t]/, '')
        price.gsub!(/lb/, ' lb')
        price.gsub!(/ea/, ' ea')
        price.gsub!(/\$\d+/) {|num| '$%.02f' % (num.delete('$').to_i / 100.0) }

        flyer_data[category_name].items << Item.create(:price => price,
          :name => item.search('p.productTitle').text.gsub(/[\r\n\t]/, ''),
          :description => item.search('p span').text.gsub(/[\r\n\t]/, ''),
          :store => store_name)
      end
    end   
  end
end
