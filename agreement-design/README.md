
# Agreement Design

this is a prototype for an agreement design system. In line with 
[ADR 0010 - use shared drfinition of cmp agreement](https://github.com/Crown-Commercial-Service/CCS-Architecture-Decision-Records/blob/master/doc/adr/0010-use-shared-definition-of-cmp-agreement-when-building-all-cmp-services.md) we want to define the metamodel
for Commertial Agreements and supporting data in a common way, so all
services, interfaces and data types are consistent. 

This prototype

- defines a common metamodel
- models a number of agreement categories (as alpha prototypes, not as definitive representations)
- produces API definitions such as Swagger
- possibly produces domain objects (though these should probably be created from API specs)
- possibly produces data domain descriptions, e.g. Ruby-on-Rails schema records


# Things to see

the [agreements](agreements/) directory defines our [agreements metamodel](model/agreement.rb) and our 
[reference agreements and catalogues](model/fm.rb) 
(example for fm given)

the build script generates [outputs](gen) including

- [data files](gen/data) showing the agreements and catalogue entries
   - for instance, can bulk load [jsonlines](gen/data/fm_catalogue.jsonlines) for FM catalogue into search cluster
- a [picture](gen/images/metamodel.jpg) of the metamodel
- documentation for the agreements and metamodel

# Requirements

- graphviz (for diagrams§)

# To do

- [ ] add reference data for Teachers
    - define model for framework
    - define reference model for offers (and elucidate the model for suppliers, contacts)
    - load mapping from spreadsheet and generate data file
    - load into search
    - map some searches
    - understand school reference data lookup to find school code and location
    - understand crow-fly filter
    - refine expressions of need to support the requirements
- [ ] add reference data for Facilities Management


