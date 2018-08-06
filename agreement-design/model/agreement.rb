require_relative '../src/data_model'
include DataModel
require_relative 'party'


domain :Agreements do

  datatype :ItemParameter do
    attribute :id, String
    attribute :detail, String
    attribute :valueMin, String
    attribute :valueMax, String
    attribute :type, String
  end

  datatype :Agreement do
    attribute :id, String
    attribute :item_params, Agreements::ItemParameter, ONE_TO_MANY
  end

  datatype :Framework, Agreements::Agreement do
    attribute :fwk_id, String, "RM number"
  end

  datatype :Lot, Agreements::Agreement do
    attribute :fwk_id, String, "Part of framework", :links => Agreements::Framework
  end


  datatype :Item do
    attribute :id, String
    attribute :params, String, :links => Agreements::ItemParameter
    attribute :detail, String
    attribute :value, String
  end

  datatype :Catalogue do
    attribute :id, String
    attribute :items, Agreements::Item, ONE_TO_MANY
    attribute :agreement, String, :links => Agreements::Agreement
  end

  datatype :Offer, Agreements::Agreement do
    attribute :supplier_id, String, :links => Parties::Supplier
  end

end

