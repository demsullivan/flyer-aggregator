require './models/company'

if Company.count == 0
  companies = [
               {:name => "No Frills", :base_url => "http://www.nofrills.ca/LCLOnline", :parser_name => "LoblawsValueBrand"},
               {:name => "Real Canadian Superstore", :base_url => "http://www.superstore.ca/LCLOnline", :parser_name => "LoblawsValueBrand"},
               {:name => "Loblaws", :base_url => "http://www.loblaws.ca/en_CA/", :parser_name => "Loblaws"}
               ]

  companies.each do |c|
    company = Company.create(c)
    puts "Created company #{company[:name]}."
  end
end
