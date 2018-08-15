### framework FM 
   - id FM
   - fwk_number RM8330
   - description This agreement is for the provision of Facilities Management
### lot FM.1a 
   - id FM.1a
   - fwk_id FM
   - description £0M-£7M
#### environmental cleaning service FM.1a-C.3 
     - id FM.1a-C.3
     - name environmental cleaning service
##### detail price-per-area 
       - id price-per-area
       - type Currency
       - standard CCS-building-area-method
       - reference per square metre
##### detail sector 
       - id sector
       - type Picklist
       - option.1 central
       - option.2 school
       - standard CCS-FM-sectornames
### catalogue FM catalogue 
   - id FM catalogue
#### item  
     - param FM.1a-C.3
##### variable  
       - param.1 price-per-area
       - value £50
##### variable  
       - param.1 sector
       - value central
#### item  
     - param FM.1a-C.3
##### variable  
       - param.1 price-per-area
       - value £45
##### variable  
       - param.1 sector
       - value schools
#### offer  
     - supplier_id XYZ corp
     - item_id FM.1a-C.3
##### variant  
###### variable  
         - param.1 price-per-area
         - value £30
###### variable  
         - param.1 sector
         - value central
###### variable  
         - param.1 location
         - value london
##### variant  
###### variable  
         - param.1 price-per-area
         - value £20
###### variable  
         - param.1 sector
         - value schools
