module FlyerAjax
  class Controller < Sinatra::Base

    get '/ajax/store_selection/get_provinces' do
      unless request["company_id"].nil?
        content_type :json
        c = Company.find(request["company_id"].to_i)
        c.parser.provinces.to_json
      end
    end

    get '/ajax/store_selection/get_cities' do
      unless request["company_id"].nil? and request["province"].nil?
        content_type :json
        c = Company.find(request["company_id"].to_i)
        c.parser.cities(request["province"]).to_json
      end
    end

    get '/ajax/store_selection/get_stores' do
      unless request["company_id"].nil? and request["province"].nil? and request["city"].nil?
        content_type :json
        c = Company.find(request["company_id"].to_i)
        c.parser.stores(request["province"], request["city"]).to_json
      end
    end

    post '/ajax/store_selection/add_store' do
      unless request["company_id"].nil? and request["store_id"].nil?
        user_store = UserStore.create :ar_users_id => current_user.id, :companies_id => request["company_id"], :store_id => request["store_id"]
        user_store.save
      end
  end
end
