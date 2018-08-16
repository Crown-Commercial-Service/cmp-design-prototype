require_relative '../src/data_model'
include DataModel

domain :Geographic do

  datatype :AreaCode do
    attribute :name, String
    attribute :description, String
    attribute :subcode, :AreaCode, ZERO_TO_MANY, "UUID or Salesforce ID?"
  end

end

#TODO load these from NUTS config file
Geographic.new :NUTS do

  # made up codes
  UK = areacode do
    name :UK
    NE = subcode do
      name :UKC; description "North East";
      subcode do
        name :UKC1; description "Tees Valley and County Durham";
      end
    end
    London = subcode do
      name :UKL; description "London";
    end
  end
end