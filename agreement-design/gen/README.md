

Generated files are generated from 
[data model definitions](../model)
to create various useful output formats
such as json files to load framework definitions
into databases.

# Loading into Elasticsearch

For example, loading more than one agreement's offerings into a single offering index:
```shell
 curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/offerings/offerings/_bulk --data-binary @ teacher-recruitment-test-offers.jsonlines 
 curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/offerings/offerings/_bulk --data-binary @teacher-recruitment-test-offers.jsonlines 
```

And adding Supply Teachers to an agreements index

```shell
 curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/agreements/agreements/_bulk --data-binary @agreements.jsonlines
```