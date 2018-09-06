require_relative '../src/data_model'
require_relative 'party'
require_relative 'geographic'
include DataModel

domain :Agreements do

  UNITS = Selection(:Area, :Commission, :Commission)
  CLASSIFICATION_SCHEMES = Selection(:CPV, :CPVS, :UNSPSC, :CPV, :OKDP, :OKPD, :CCS)
  code(:CCS, description: "CCS invented schemes")

  datatype(:ItemType,
           description:
"Defines the items that can be offered in any selected agreements
Agreements hava a number of items that can have values defining the agreement. The Items should
constrain the key quantifiable elements of an agreement award. A supplier may provide additional
variable facts in their Offer to supplement the description of how they support the agreement.") {

    attribute :id, String, "The code id, which must be unique across all schemes"
    attribute :scheme_id, CLASSIFICATION_SCHEMES, "The classiciation scheme id"
    attribute :description, String
    attribute :keyword, String, ZERO_TO_MANY
    attribute :uri, String, " URI for the code within the scheme defining this type "
    attribute :code, String, " Code within the scheme defining this type "
    attribute :unit, UNITS, " define the units, if one units matches "
  }

  TYPES_OF_EXPRESSION_OF_NEED = Selection(:Budget, :Location, :Service)
  code(:Budget, description:
"What is the budget the buyer has for their need?
Match the budget to the value range of the agreement, and the value range of supplier offers.
Matching the budget will probably require evaluation of offer prices.")
  code(:Location, description:
"Where is the need?
Match location needs to locations of offers")
  code(:Service, description:
"What sort of things do they need?
Match the service to item types, their keywords, and offering titles.")

  datatype(:ExpressionOfNeed,
           description:
" Defines a buyer's need which can be matched to agreement items and other details
The need matches closely to our definitions of agreements under 'items types' and their classification
schemes, but is not a one-to-one match.") {
    attribute :buyer_id, String, "The buyer expressing the need"
    attribute :kind, Selection(:Budget, :Location, :Service)
    attribute :value, String
    attribute :unit, UNITS, "The units typically used to express the need"
  }

  datatype(:Agreement,
           description: "General definition of Commercial Agreements") {

    # identify the agreement
    attribute :kind, Selection(:Framework, :Lot, :Contract),
              #TODO doc should enumeration selections
              "Kind of agreement, including :Framework, :Lot, :Contract"
    attribute :id, String, "uuid of agreeement"
    attribute :name, String, "uuid of agreeement"
    attribute :version, String, "semantic version id of the form X.Y.Z"
    attribute :start_date, Date
    attribute :end_date, Date
    attribute :description, String, "Describe the agreement"
    attribute :fwk_number, String, "Framework (RM) number of related framework if required. @Example RM123"
    attribute :sf_typ, String, "SalesForce data type"
    attribute :sf_is, String, "SalesForce row id"
    attribute :offerType, String, "Name of the subclass of the Offering, supporting the Agreement"

    # structure of agreement
    attribute :part_of_id, String, "Agreement this is part of, applicable only to Lots", links: :Agreement
    attribute :conforms_to_id, String, "Agreement this conforms to, such as a Contract conforming to a Framework", links: :Agreement
    attribute :item_type, :ItemType, ZERO_TO_MANY,
              "describe the items that can be offered under the agreement"

    # Qualifications
    attribute :min_value, Integer, ZERO_OR_ONE, "Minimum value of award, in pounds sterling"
    attribute :max_value, Integer, ZERO_OR_ONE, "Maximum value of award, in pounds sterling"

  }

  datatype(:Item,
           description: "Specifies the value of an item that is being offered for an agreement") {
    attribute :type_id, String, " type of the item ", links: :ItemType
    attribute :unit, UNITS, " define the units "
    attribute :value, Object, "an object of the type matching type->units"
  }

  datatype(:Offering,
           description: " Supplier offering against an item or items of an agreement.
This may be extended for different agreements. A supplier may provide additional
variable facts in their Offer to supplement the description of how they support the agreement. ") {
    attribute :agreement_id, String, "The agreement this offering relates to", links: :Agreement
    attribute :supplier_id, String, links: Parties::Party
    attribute :id, String, "unique id for the offering across all offerings, suppliers and frameworks"
    attribute :name, String
    attribute :description, String
    attribute :item, :Item, ZERO_TO_MANY, "details of the item"
    # Qualifications
    attribute :location_id, String, ONE_TO_MANY,
              "Pick list of applicable regions. There must be at least one, even if it is just 'UK'",
              links: Geographic::AreaCode
    attribute :sector_id, String, ZERO_TO_MANY,
              "Pick list of applicable sectors.
If set offering is only to be shown to users proven to belong to the sectors given", links: Parties::Sector
  }

  datatype(:Catalogue,
           description: " A collection of supplier offerings against an item, for an agreement ") {
    attribute :offers, :Offering, ZERO_TO_MANY, "description of the item"
  }

  datatype(:Involvement,
           description: "Involvement relationship between a party and an agreement
Technology strategy documents call this type 'interest' but perhaps this could
be confused with the accounting interest") {
    attribute :agreement_id, String, "The agreement this interest relates to", links: :Agreement
    attribute :party_id, String, "The party this interest relates to", links: Parties::Party
    attribute :role, Selection(:AwardedSupplier, :AwardedBuyer, :SupplyingQuote, :RequestingQuote, :Etc),
              "The role of the party in the involvment"
  }

end