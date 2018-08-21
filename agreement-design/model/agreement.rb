require_relative '../src/data_model'
require_relative 'party'
require_relative 'geographic'
include DataModel

domain :Category do

  SECTOR = Selection(:ALL, :Education, :CentralGov, :WiderGov, :Etc)

  datatype(:QualifiedElement,
           description: "Any datatype with standard qualifiers on it") {
    # constraints
    attribute :start_date, Date, ZERO_OR_ONE
    attribute :end_date, Date, ZERO_OR_ONE
    attribute :min_value, Integer, ZERO_OR_ONE, "Minimum value of award, in pounds sterling"
    attribute :max_value, Integer, ZERO_OR_ONE, "Maximum value of award, in pounds sterling"
    attribute :sector, SECTOR,
              "Pick list of applicable sectors. TO DO: is this a nested or more complex list?",
              ZERO_TO_MANY
    attribute :location_id, String, ZERO_TO_MANY,
              "Pick list of applicable regions. TO DO: is this a nested or more complex list?",
              links: Geographic::AreaCode
  }

  datatype(:ItemType, extends: Category::QualifiedElement,
           description: " Defines the items that can be offered in any given agreement ") {
    attribute :id, String
    attribute :name, String
    attribute :description, String
    attribute :keyword, String, ZERO_TO_MANY
    attribute :standard, String, " which standard defines the item type, such as UBL2 .1 "
    attribute :code, String, ZERO_TO_MANY, " codes within standard, such as UBL2 .1 "
    attribute :units, Selection(:Area, :Currency), " define the units "
  }

  datatype(:Agreement, extends: Category::QualifiedElement,
           description: "General definition of Commercial Agreements") {

    # identify the agreement
    attribute :kind, Selection(:Framework, :Lot, :Contract),
              #TODO doc should enumeration selections
              "Kind of agreement, including :Framework, :Lot, :Contract"
    attribute :id, String, "uuid of agreeement"
    attribute :name, String, "uuid of agreeement"
    attribute :version, String, "semantic version id of the form X.Y.Z"
    attribute :description, String, "Describe the agreement"
    attribute :fwk_number, String, "Framework (RM) number of related framework if required. @Example RM123"
    attribute :sf_typ, String, "SalesForce data type"
    attribute :sf_is, String, "SalesForce row id"

    # structure of agreement
    attribute :part_of_id, String, "Agreement this is part of, applicable only to Lots", links: :Agreement
    attribute :conforms_to_id, String, "Agreement this conforms to, such as a Contract conforming to a Framework", links: :Agreement
    attribute :item_types, :ItemType, ZERO_TO_MANY,
              "describe the items that can be offered under the agreement"
  }

  datatype(:Item,
           description: "Specifices the items that are being offered for an agreement") {
    attribute :type, String, "description of the item", links: :ItemType
    attribute :value, Object, "an object of the type matching type->units"
  }

  datatype(:Offering, extends: Category::QualifiedElement,
           description: " Supplier offering against an item, given a number of constraints. This may be extended for different agreements ") {
    attribute :supplier_id, String, links: Parties::Supplier
    attribute :offerType, String, "subclass of the Offering, based on the Agreement"
    attribute :name, String, links: Parties::Supplier
    attribute :agreement_id, String, "The agreement this offering relates to", links: :Agreement
    attribute :item, :Item, "description of the item"
  }

  datatype(:Catalogue,
           description: " Supplier offering against an item, given a number of constraints ") {
    attribute :offers, :Offering, ZERO_TO_MANY, "description of the item"
  }

end