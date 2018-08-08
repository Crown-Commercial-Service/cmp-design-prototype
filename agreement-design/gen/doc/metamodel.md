 # Category
## ItemParameter
  Defines the meaning of Items in Catalogues

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|detail|String|1||
|keyword|String|*||
|valueMin|String|1||
|valueMax|String|1||
|type|String|1|One of: String, Currency, Location, Amount|
|standard|String|1|which standard defines the item type, such as UBL2.1|
|reference|String|1|reference within standard, such as UBL2.1|
## Agreement
  General definition of Commercial Agreements

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|item_params|Category::ItemParameter|*||
|version|String|1|semantic version id of the form X.Y.Z|
|start_date|Date|1||
|end_date|Date|1||
## Framework extends Category::Agreement
  A kind of Framework used for calloffs, composed of Lots

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|item_params|Category::ItemParameter|*||
|version|String|1|semantic version id of the form X.Y.Z|
|start_date|Date|1||
|end_date|Date|1||
|fwk_id|String|1|Such as the RM number|
## Lot extends Category::Agreement
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|item_params|Category::ItemParameter|*||
|version|String|1|semantic version id of the form X.Y.Z|
|start_date|Date|1||
|end_date|Date|1||
|fwk_id|String|1|Part of framework|
## Item
  Something offered to a buyer as part of a contract.Items are defined in Catalogues.

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|Item id, possibly a concatentation of the standard (in params) and the catalogue and an incrementatl id?|
|params|String|1||
|description|String|1||
|value|String|1||
## Catalogue
  A collection of items that can be bought via an Agreement.

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|items|Category::Item|*||
|agreement_id|String|1||
## Offer
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|Offer id, probably a UUID|
|item_id|String|1||
|catalogue_id|String|1||
|supplier_id|String|1||
|description|String|1|Description of the offer|
## Award
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|buyer_id|String|1||
 # Parties
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
