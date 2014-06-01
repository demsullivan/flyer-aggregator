Sinatra::SimpleAuthentication.require_adapter

module Sinatra
  module SimpleAuthentication
    module Models
      module ActiveRecord
        class ArUser < ::ActiveRecord::Base
          has_many :user_stores
        end
      end
    end
  end
end
