##Metamodels

Metamodels are ruby files that define our agreement
data metamodels models, and supporting models. For 
example. The main metamodles are

- Agreement
- Party
- Geographic

We also extend these (optionally) for each `Agreement`
since different agreements may have special Offerings.
For example the standard `Offering` type has the attributes 
including

- Item(s)
- Name 
- Supplier_id

And the [Supply Teacher framework](supply_teachers.rb) lots have Offerings which add
framework specific attributes such as:

- Branch name
- Branch contact

So the Supply Teacher Framework extends our metamodel.

Once we have the metamodel, CCS agreements are defined 
by instanciating the relevant model domain, such as (in Ruby)

```ruby
Agreements.new(:SomeCategory) {

  agreement {
    kind :Framework
    id SOME_ID
    fwk_number "RM8330"
    version "0.1.0"
    description "This agreement is for the provision of Stuff"
    start_date date(2018, 10, 01)
  }
}
```

Specifically, Catalogues are defined by creating instances
of Offerings, either in data files, in code, or through
an API. For example see the catalogue output as 
[jsonlines](../gen/data/teacher-recruitment-test-offers.jsonlines)