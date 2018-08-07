require_relative '../src/data_model'
include DataModel
require_relative 'party'
require 'date'


domain :Agreements do

  datatype :ItemParameter do
    attribute :id, String
    attribute :detail, String
    attribute :valueMin, String
    attribute :valueMax, String
    attribute :type, String, "One of: String, Currency, Location, Amount"
    attribute :standard, String, "which standard defines the item type, such as UBL2.1"
    attribute :reference, String, "reference within standard, such as UBL2.1"
  end

  datatype :Agreement do
    attribute :id, String
    attribute :item_params, Agreements::ItemParameter, ZERO_TO_MANY
    attribute :version, String, "semantic version id of the form X.Y.Z"
    attribute :start_date, Date
    attribute :end_date, Date
  end

  datatype :Framework, Agreements::Agreement do
    attribute :fwk_id, String, "Such as the RM number"
  end

  datatype :Lot, Agreements::Agreement do
    attribute :fwk_id, String, "Part of framework", :links => Agreements::Framework
  end


  datatype :Item do
    attribute :id, String
    attribute :params, String, :links => Agreements::ItemParameter
    attribute :description, String
    attribute :value, String
  end

  datatype :Catalogue do
    attribute :id, String
    attribute :items, Agreements::Item, ZERO_TO_MANY
    attribute :agreement, String, :links => Agreements::Agreement
  end

  datatype :Offer, Agreements::Catalogue do
    attribute :supplier_id, String, :links => Parties::Supplier
    attribute :description, String, "Description of the offer"
  end

end

