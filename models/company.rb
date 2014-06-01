class Company < ActiveRecord::Base
  has_many :user_stores

  def parser
    begin
      klass = Stores.const_get(parser_name.to_sym).new(self)
    rescue
      nil
    end
  end
end
