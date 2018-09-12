

Generated files are generated from 
[data model definitions](../model)
to create various useful output formats
such as json files to load framework definitions
into databases.

# Loading into Elasticsearch

For example, loading more than one agreement's offerings into a single offering index:
```shell
 curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/offerings/offerings/_bulk --data-binary @"data/teacher-recruitment-test-offers.jsonlines"
 curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/offerings/offerings/_bulk --data-binary @"data/teacher-recruitment-test-offers.jsonlines" 
 curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/agreements/agreements/_bulk --data-binary @"data/agreements.jsonlines" 
```

And adding Supply Teachers to an agreements index

```shell
 curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/agreements/agreements/_bulk --data-binary @agreements.jsonlines
```

# Sample queries

POST /offerings/_search
{
  "query": {
    "match_all": {
    }
  }
}

POST /offerings/_search
{
  "query": {
    "multi_match": {
      "query": "qualified teacher",
      "fields": [ "id", "name" ] 
    }
  }
}


POST /offerings/_search
{
  "query": {
    "bool": {
      "must": [ { "match" : {"name": "qualified teacher" }}],
      "filter": [ {"term" : { "supplier_id:": "Vendor 2" }}] 
    }
  }
}

POST /offerings/_search
{
  "query": {
    "bool": {
      "must": {
        "exists": {
          "field": "sector_id"
        }
      }
    }
  }
}





