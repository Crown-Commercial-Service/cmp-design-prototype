## QualifiedElement
  Any datatype with standard qualifiers on it

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|start_date|Date|1||
|end_date|Date|1||
|min_value|Integer|1|Minimum value of award, in pounds sterling|
|max_value|Integer|1|Maximum value of award, in pounds sterling|
|sector|Selection_ALL_Education_CentralGov_WiderGov|*|Pick list of applicable sectors. TO DO: is this a nested or more complex list?|
|location_id|String|*|Pick list of applicable regions. TO DO: is this a nested or more complex list?|
## ItemType extends Category::QualifiedElement
   Defines the items that can be offered in any given agreement 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|start_date|Date|1||
|end_date|Date|1||
|min_value|Integer|1|Minimum value of award, in pounds sterling|
|max_value|Integer|1|Maximum value of award, in pounds sterling|
|sector|Selection_ALL_Education_CentralGov_WiderGov|*|Pick list of applicable sectors. TO DO: is this a nested or more complex list?|
|location_id|String|*|Pick list of applicable regions. TO DO: is this a nested or more complex list?|
|id|String|1||
|name|String|1||
|description|String|1||
|keyword|String|*||
|standard|String|1| which standard defines the item type, such as UBL2 .1 |
|code|String|*| codes within standard, such as UBL2 .1 |
|units|Selection_Area_Currency|1| define the units |
## Agreement extends Category::QualifiedElement
  General definition of Commercial Agreements

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|start_date|Date|1||
|end_date|Date|1||
|min_value|Integer|1|Minimum value of award, in pounds sterling|
|max_value|Integer|1|Maximum value of award, in pounds sterling|
|sector|Selection_ALL_Education_CentralGov_WiderGov|*|Pick list of applicable sectors. TO DO: is this a nested or more complex list?|
|location_id|String|*|Pick list of applicable regions. TO DO: is this a nested or more complex list?|
|kind|Selection_Framework_Lot_Contract|1|Kind of agreement, including :Framework, :Lot, :Contract|
|id|String|1|uuid of agreeement|
|name|String|1|uuid of agreeement|
|version|String|1|semantic version id of the form X.Y.Z|
|description|String|1|Describe the agreement|
|fwk_number|String|1|Framework (RM) number of related framework if required. @Example RM123|
|sf_typ|String|1|SalesForce data type|
|sf_is|String|1|SalesForce row id|
|part_of_id|String|1|Agreement this is part of, applicable only to Lots|
|conforms_to_id|String|1|Agreement this conforms to, such as a Contract conforming to a Framework|
|item_types|Category::ItemType|*|describe the items that can be offered under the agreement|
## Item
  Specifices the items that are being offered for an agreement

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|type|String|1|description of the item|
|value|Object|1|an object of the type matching type->units|
## Offering extends Category::QualifiedElement
   Supplier offering against an item, given a number of constraints 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|start_date|Date|1||
|end_date|Date|1||
|min_value|Integer|1|Minimum value of award, in pounds sterling|
|max_value|Integer|1|Maximum value of award, in pounds sterling|
|sector|Selection_ALL_Education_CentralGov_WiderGov|*|Pick list of applicable sectors. TO DO: is this a nested or more complex list?|
|location_id|String|*|Pick list of applicable regions. TO DO: is this a nested or more complex list?|
|supplier_id|String|1||
|offerType|String|1|subclass of the Offering, based on the Agreement|
|name|String|1||
|agreement_id|String|1|The agreement this offering relates to|
|item|Category::Item|1|description of the item|
## Catalogue
   Supplier offering against an item, given a number of constraints 

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|offers|Category::Offering|*|description of the item|
## Party
  

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
|start_date|Date|1||
|end_date|Date|1||
|min_value|Integer|1|Minimum value of award, in pounds sterling|
|max_value|Integer|1|Maximum value of award, in pounds sterling|
|sector|Selection_ALL_Education_CentralGov_WiderGov|*|Pick list of applicable sectors. TO DO: is this a nested or more complex list?|
|location_id|String|*|Pick list of applicable regions. TO DO: is this a nested or more complex list?|
|supplier_id|String|1||
|offerType|String|1|subclass of the Offering, based on the Agreement|
|name|String|1||
|agreement_id|String|1|The agreement this offering relates to|
|item|Category::Item|1|description of the item|
|sc_cleared|String|1||
