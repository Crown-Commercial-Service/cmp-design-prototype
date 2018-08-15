## VariableParameter
  Defines the meaning of Items in Catalogues

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|detail|String|1||
|valueMin|String|1||
|valueMax|String|1||
|option|String|*|pick from one|
|type|String|1|One of: String, Currency, Location, Amount, Document|
|default|String|1||
|standard|String|1|which standard defines the item type, such as UBL2.1|
|reference|String|1|reference within standard, such as UBL2.1/|
## ItemParameter
  Defines the meaning of Items in Catalogues

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|name|String|1||
|detail|Category::VariableParameter|*|define the fixed variables for the item on the agreement|
|keyword|String|*||
|standard|String|1|which standard defines the item type, such as UBL2.1|
|code|String|*|codes within standard, such as UBL2.1|
|option|Category::VariableParameter|*|define the optional offer variables for offers on the item|
## Agreement
  General definition of Commercial Agreements

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|description|String|1||
|item|Category::ItemParameter|*|item params describe the composition of the agreement|
|version|String|1|semantic version id of the form X.Y.Z|
|start_date|Date|1||
|end_date|Date|1||
## Framework extends Category::Agreement
  A kind of Framework used for calloffs, composed of Lots

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|description|String|1||
|item|Category::ItemParameter|*|item params describe the composition of the agreement|
|version|String|1|semantic version id of the form X.Y.Z|
|start_date|Date|1||
|end_date|Date|1||
|fwk_number|String|1|Such as the RM number|
## Lot extends Category::Agreement
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|description|String|1||
|item|Category::ItemParameter|*|item params describe the composition of the agreement|
|version|String|1|semantic version id of the form X.Y.Z|
|start_date|Date|1||
|end_date|Date|1||
|fwk_id|String|1|Part of framework with this id (not fwk_no)|
## Variable
  detail for an item or need

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|index|String|1|optional index where many variable exist for the same parameter|
|value|String|1||
|param|String|*||
## Item
  Something offered to a buyer as part of a contract.Items are defined in Catalogues.

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|Item id, possibly a concatentation of the standard (in params) and the catalogue and an incrementatl id?|
|param|String|1||
|description|String|1||
|variable|Category::Variable|*||
## Offer
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1|Offer id, probably a UUID|
|item_id|String|1||
|variant|Category::Item|*||
|supplier_id|String|1||
|description|String|1|Description of the offer|
## Catalogue
  A collection of items that can be bought via an Agreement.

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|id|String|1||
|item|Category::Item|*||
|agreement_id|String|1||
|offer|Category::Offer|*||
## Award
  

|attribute|type|multiplicity|description|
|---------|----|------------|-----------|
|buyer_id|String|1||
|offer_id|String|*||
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
