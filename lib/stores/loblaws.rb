require File.join(File.expand_path('..', __FILE__), 'base')

module Stores
  class Loblaws < Stores::Base
    def provinces
      p = get('store_selector_overlay.jsp', {:width => 730, :height => 300})
      p.search('select#dd_banner_province option').each_with_object({}) do |provinces, el|
        provinces[el.attribute('value').value] = el.children.inner_text.strip
      end
    end

    def cities(province)
      p = post('store_selector.jsp', :form_action => 'storeSelector', :provinceCode => province,
               :city => '', :storeId => '')
      JSON::parse(p.body)['cities']
    end

    def stores(province, city)
      p = post('store_selector.jsp', :form_action => 'storeSelector', :provinceCode => province,
               :city => city, :storeId => '')
      JSON::parse(p.body)['stores']
    end

    def categories(store_id)
      p = get('flyers_landing_page.jsp', :flyerView => 'item', :storeId => store_id)
      
      link_regex = /flyerView=(?<view>\w+)&storeId=(?<store_id>\d+)&categoryId=(?<category_id>\d+)/

      if block_given?
        p.links_with(:href => /categoryId/).each do |link|
          m = link_regex.match(link.href)
          yield :id => m['category_id'], :name => link.text.strip unless m.nil?
        end
      else
        p.links_with(:href => /categoryId/).each_with_object([]) do |categories, link|
          m = link_regex.match(link.href)
          categories << {:id => m['category_id'], :name => link.text.strip} unless m.nil?
        end
      end
    end

    def items(category_id, store_id)
      p = get('flyers_landing_page.jsp', :flyerView => 'item', :storeId => store_id, :categoryId => category_id)

      if block_given?
        p.search('div.searchResultsGridItem').each do |item|
          yield parse_item(item)
        end
      else
        p.search('div.searchResultsGridItem').each_with_object([]) do |items, item|
          items << parse_item(item)
        end
      end
    end

    private
      def parse_item(item)
        price = item.search('p.productPrice').text.gsub(/[\r\n\t]/, '')
        price.gsub!(/lb/, ' lb')
        price.gsub!(/ea/, ' ea')
        price.gsub!(/\$\d+/) {|num| '$%.02f' % (num.delete('$').to_i / 100.0) }

        return :price => price, :name => item.search('p.productTitle').text.gsub(/[\r\n\t]/, ''),
        :description => item.search('p span').text.gsub(/[\r\n\t]/, '')
      end
  end
end
