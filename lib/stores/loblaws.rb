require File.join(File.expand_path('..', __FILE__), 'base')

module Stores
  class Loblaws < Stores::Base

    # element :province, 'ul.store-select li a'
    # element :city, 'ul.store-select li a'
    # element :store
    # element :item, 'div.product'
    # element :item_price, 'p.price'
    # element :item_name, 'h3.title'
    # element :item_description, 'div.more p span'

    def provinces
      p = get('store-list-page.html')
      p.search('ul.store-select li a').each_with_object({}) do |link, provinces|
        m = /store-list-page\.(?<province>\w+)\.html/.match link.attribute('href')
        provinces[m['province']] = link.text.strip
      end
    end

    def cities(province)
      p = get("store-list-page.#{province}.html")
      p.search('ul.store-select li a').each_with_object([]) do |link, cities|
        m = /store-list-page\.(?<province>\w+)\.(?<city>[a-zA-Z ]+)\.html/.match link.attribute('href').value
        cities << m['city']
      end
    end

    def stores(province, city)
      p = get("store-list-page.#{province}.#{city}.html")
      p.search('div.store-info').each_with_object([]) do |div, stores|
        name = div.search('h3.title').inner_text.strip
        link = div.search('div.store-buttons a.view-flyer-button').first        
        m = /storenum\@(?<storeId>\d+)\.html/.match link.attribute('href').value
        id = m['storeId'] unless m.nil?
        stores << {:name => name, :id => id}
      end
    end

    def categories(store_id)
      p = get("flyers.banner@LOB.storenum@#{store_id}.html")

      link_regex = /categoryId\@lclonline\!Flyers,Category,(?<category_id>\S+).html/
      
      if block_given?
        p.links_with(:href => /categoryId/).each do |link|
          m = link_regex.match(link.href)
          yield :id => m['category_id'], :name => link.text.strip unless m.nil?
        end
      else
        p.links_with(:href => /categoryId/).each_with_object([]) do |link, categories|
          m = link_regex.match(link.href)
          categories << {:id => m['category_id'], :name => link.text.strip} unless m.nil?
        end
      end
    end

    def items(category_id, store_id)
      p = get("flyers.banner@LOB.storenum@#{store_id}.next@1.categoryId@lclonline!Flyers,Category,#{category_id}.html")

      if block_given?
        p.search('div.product').each do |item|
          yield parse_item(item)
        end
      else
        p.search('div.product').each_with_object([]) do |item, items|
          items << parse_item(item)
        end
      end
    end

    private
      def parse_item(item)
        price = item.search('p.price').text.gsub(/[\r\n\t]/, '')
        price.gsub!(/lb/, ' lb')
        price.gsub!(/ea/, ' ea')
        puts price
        price.gsub!(/\$\d+/) {|num| num.length >= 4 ? "#{num[0..-3]}.#{num[-2..num.length]}" : num }

        return :price => price, :name => item.search('h3.title').text.gsub(/[\r\n\t]/, ''),
        :description => item.search('div.more p span').text.gsub(/[\r\n\t]/, '')
      end
  end
end
