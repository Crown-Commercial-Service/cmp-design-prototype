require_relative '../src/data_model'
require_relative 'party'
require 'date'
include DataModel

domain :Category do

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
    attribute :item_params, Category::ItemParameter, ZERO_TO_MANY, :links => Category::ItemParameter
    attribute :version, String, "semantic version id of the form X.Y.Z"
    attribute :start_date, Date
    attribute :end_date, Date
  end

  datatype :Framework, Category::Agreement do
    attribute :fwk_id, String, "Such as the RM number"
  end

  datatype :Lot, Category::Agreement do
    attribute :fwk_id, String, "Part of framework", :links => Category::Framework
  end

  datatype :Item do
    attribute :id, String, "Item id, possibly a concatentation of the standard (in params) and the catalogue and an incrementatl id?"
    attribute :params, String, :links => Category::ItemParameter
    attribute :description, String
    attribute :value, String
  end

  datatype :Catalogue do
    attribute :id, String
    attribute :items, Category::Item, ZERO_TO_MANY, :links => Category::Item
    attribute :agreement_id, String, :links => Category::Agreement
  end

  datatype :Offer do
    attribute :id, String, "Offer id, probably a UUID"
    attribute :item_ids, String, ZERO_TO_MANY, :links => Category::Item
    attribute :supplier_id, String, :links => Parties::Supplier
    attribute :description, String, "Description of the offer"
  end

  datatype :Award do
    attribute :buyer_id, String, :links => Parties::Buyer
  end

end

