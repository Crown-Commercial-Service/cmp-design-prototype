# Data model: Agreements
## ItemType
  Defines the items that can be offered in any selected agreements
Agreements hava a number of items that can have values defining the agreement. The Items should
constrain the key quantifiable elements of an agreement award. A supplier may provide additional
variable facts in their Offer to supplement the description of how they support the agreement.

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|The code id, which must be unique across all schemes|
|scheme_id|(CPV,CPVS,UNSPSC,CPV,OKDP,OKPD,CCS)|1|The classiciation scheme id|
|description|String|1||
|keyword|String|*||
|uri|String|1| URI for the code within the scheme defining this type |
|code|String|1| Code within the scheme defining this type |
|unit|(Area,Commission,Currency)|1| define the units, if one units matches |
## ExpressionOfNeed
   Defines a buyer's need which can be matched to agreement items and other details
The need matches closely to our definitions of agreements under 'items types' and their classification
schemes, but is not a one-to-one match.

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|buyer_id|String|1|The buyer expressing the need|
|kind|(Budget,Location,Service)|1||
|value|String|1||
|unit|(Area,Commission,Currency)|1|The units typically used to express the need|
## Agreement
  General definition of Commercial Agreements

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|kind|(Framework,Lot,Contract)|1|Kind of agreement, including :Framework, :Lot, :Contract|
|id|String|1|uuid of agreeement|
|name|String|1|uuid of agreeement|
|version|String|1|semantic version id of the form X.Y.Z|
|start_date|Date|1||
|end_date|Date|1||
|description|String|1|Describe the agreement|
|fwk_number|String|1|Framework (RM) number of related framework if required. @Example RM123|
|sf_typ|String|1|SalesForce data type|
|sf_id|String|1|SalesForce row id|
|offerType|String|1|Name of the subclass of the Offering, supporting the Agreement|
|part_of_id|String -> Agreements::Agreement|1|Agreement this is part of, applicable only to Lots|
|conforms_to_id|String -> Agreements::Agreement|1|Agreement this conforms to, such as a Contract conforming to a Framework|
|item_type|Agreements::ItemType|*|describe the items that can be offered under the agreement|
|min_value|Integer|0..1|Minimum value of award, in pounds sterling|
|max_value|Integer|0..1|Maximum value of award, in pounds sterling|
## Item
  Specifies the value of an item that is being offered for an agreement

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|type_id|String -> Agreements::ItemType|1| type of the item |
|unit|(Area,Commission,Currency)|1| define the units |
|value|Object|1|an object of the type matching type->units|
## Offering
   Supplier offering against an item or items of an agreement.
This may be extended for different agreements. A supplier may provide additional
variable facts in their Offer to supplement the description of how they support the agreement. 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|agreement_id|String -> Agreements::Agreement|1|The agreement this offering relates to|
|supplier_id|String -> Parties::Party|1||
|id|String|1|unique id for the offering across all offerings, suppliers and frameworks|
|name|String|1||
|description|String|1||
|item|Agreements::Item|*|details of the item|
|location_id|String -> Geographic::AreaCode|1..*|Pick list of applicable regions. There must be at least one, even if it is just 'UK'|
|sector_id|String -> Parties::Sector|*|Pick list of applicable sectors.
If set offering is only to be shown to users proven to belong to the sectors given|
## Catalogue
   A collection of supplier offerings against an item, for an agreement 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|offers|Agreements::Offering|*|description of the item|
## Involvement
  Involvement relationship between a party and an agreement
Technology strategy documents call this type 'interest' but perhaps this could
be confused with the accounting interest

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|agreement_id|String -> Agreements::Agreement|1|The agreement this interest relates to|
|party_id|String -> Parties::Party|1|The party this interest relates to|
|role|(AwardedSupplier,AwardedBuyer,SupplyingQuote,RequestingQuote,Etc)|1|The role of the party in the involvment|
# Codes
## CCS 
CCS invented schemes

## Budget 
What is the budget the buyer has for their need?
Match the budget to the value range of the agreement, and the value range of supplier offers.
Matching the budget will probably require evaluation of offer prices.

## Location 
Where is the need?
Match location needs to locations of offers

## Service 
What sort of things do they need?
Match the service to item types, their keywords, and offering titles.

# Data model: Parties
## Party
  
  The party is used to identify buyers and suppliers. Since some organisations act as
both buyers and suppliers we use the same record for both, but most organisations will
be one or the other. The onvolvement of the party with an agreement determine  the role in
that contenxt.
Details still to be added

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|UUID or Salesforce ID?|
|org_name|String|1|UUID or Salesforce ID?|
|supplier_registration_completed|Date|1||
|buyer_registration_completed|Date|1||
## Address
  Address should include at least addres line 1 and ideally post code.
will contain UPRN if we have derived it.
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|address_1|String|1||
|address_2|String|0..1||
|town|String|0..1||
|county|String|*||
|postcode|String|*||
|uprn|String|*||
## Contact
  
  A way of contacting a party. Store contacts in a safe identity store. Do not store personal details elsewhere.
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|a UUID for the person or contact point|
|party_id|String -> Parties::Party|1|contact is a link for this party|
|name|String|1|address of the contact point|
|address|Parties::Address|0..1|address of the contact point|
|phone|String|*|phone of the contact point|
|email|String|*|email of the contact point|
## Sector
  
  Hierarchy of sector codes delineating the party organisation
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|name|String|1||
|description|String|1||
|subsector|Parties::Sector|*||
# Data model: Geographic
## AreaCode
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|name|String|1||
|description|String|1||
|subcode|Geographic::AreaCode|*||
# Data model: SupplyTeacherOfferings
## ST_Offering extends Agreements::Offering
   An offer for ST supply
The offerings look the same for both lots - since they both relate to the same items and data

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|agreement_id|String -> Agreements::Agreement|1|The agreement this offering relates to|
|supplier_id|String -> Parties::Party|1||
|id|String|1|unique id for the offering across all offerings, suppliers and frameworks|
|name|String|1||
|description|String|1||
|item|Agreements::Item|*|details of the item|
|location_id|String -> Geographic::AreaCode|1..*|Pick list of applicable regions. There must be at least one, even if it is just 'UK'|
|sector_id|String -> Parties::Sector|*|Pick list of applicable sectors.
If set offering is only to be shown to users proven to belong to the sectors given|
|commission|String|1|The percentage the supplier charges for the item|
|duration|(Up_to_1_week,Between_1_and_12_weeks,Over_12_weeks)|1||
|branch_name|String|1|branch name from which the offer is supplied|
|branch_contact_id|String -> Parties::Contact|1|links to contact at the address|
|branch_location|String|1|postcode of branch|
|vendor_type|(Master_Vendor,Neutral_Vendor) -> Parties::Contact|1|for managed service offerings|
