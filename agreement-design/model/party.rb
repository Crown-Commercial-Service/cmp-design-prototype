require_relative '../src/data_model'
include DataModel

domain :Parties do

  # TODO fill in these types - this is just a skeleton
  datatype :Party, "Details still to be added" do
    attribute :id, String, "UUID or Salesforce ID?"
  end

  datatype :Supplier, extends: Parties::Party do

  end

  datatype :Buyer, extends: Parties::Party do

  end
end
