## ClassificationScheme
   Defines the standards schemes for items 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|(CPV,CPVS,UNSPSC,CPV,OKDP,OKPD,CCS)|1|The classiciation SCHEME id|
|title|String|1||
|description|String|1||
|uri|String|1|URL of source. See http://standard.open-contracting.org/latest/en/schema/codelists/#item-classification-scheme|
## ItemType
   Defines the items that can be offered in any selected agreements 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|The code id, which must be unique across all schemes|
|scheme_id|(CPV,CPVS,UNSPSC,CPV,OKDP,OKPD,CCS)|1|The classiciation scheme id|
|description|String|1||
|keyword|String|*||
|uri|String|1| URI for the code within the scheme defining this type |
|code|String|1| Code within the scheme defining this type |
|unit|(Area,Currency)|1| define the units, if one units matches |
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
|sf_is|String|1|SalesForce row id|
|part_of_id|String -> Category::Agreement|1|Agreement this is part of, applicable only to Lots|
|conforms_to_id|String -> Category::Agreement|1|Agreement this conforms to, such as a Contract conforming to a Framework|
|item_type|Category::ItemType|*|describe the items that can be offered under the agreement|
|min_value|Integer|0..1|Minimum value of award, in pounds sterling|
|max_value|Integer|0..1|Maximum value of award, in pounds sterling|
## Item
  Specifices the items that are being offered for an agreement

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|type|String -> Category::ItemType|*| type of the item |
|unit|(Area,Currency)|1| define the units |
|value|Object|1|an object of the type matching type->units|
## Offering
   Supplier offering against an item, given a number of constraints. This may be extended for different agreements 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|supplier_id|String -> Parties::Supplier|1||
|offerType|String|1|subclass of the Offering, based on the Agreement|
|name|String -> Parties::Supplier|1||
|agreement_id|String -> Category::Agreement|1|The agreement this offering relates to|
|item|Category::Item|1|description of the item|
|location_id|String -> Geographic::AreaCode|1..*|Pick list of applicable regions. There must be at least one, even if it is just 'UK'|
|sector|(ALL,Education,CentralGov,WiderGov,Etc)|*|Pick list of applicable sectors.|
## Catalogue
   A collection of supplier offerings against an item, for an agreement 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|offers|Category::Offering|*|description of the item|
## Party
  Details still to be added

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|UUID or Salesforce ID?|
## Supplier extends Parties::Party
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|UUID or Salesforce ID?|
## Buyer extends Parties::Party
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|UUID or Salesforce ID?|
## AreaCode
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|name|String|1||
|description|String|1||
|subcode|Geographic::AreaCode|*|UUID or Salesforce ID?|
## FM_Offering extends Category::Offering
   An offer for FM elements 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|supplier_id|String -> Parties::Supplier|1||
|offerType|String|1|subclass of the Offering, based on the Agreement|
|name|String -> Parties::Supplier|1||
|agreement_id|String -> Category::Agreement|1|The agreement this offering relates to|
|item|Category::Item|1|description of the item|
|location_id|String -> Geographic::AreaCode|1..*|Pick list of applicable regions. There must be at least one, even if it is just 'UK'|
|sector|(ALL,Education,CentralGov,WiderGov,Etc)|*|Pick list of applicable sectors.|
|sc_cleared|String|1||
