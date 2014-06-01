class UserStore < ActiveRecord::Base
  belongs_to :ar_user
  belongs_to :company
end
