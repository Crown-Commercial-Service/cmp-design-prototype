require_relative "src/diagram"
require_relative "src/doc"
require_relative "src/data"
require_relative 'model/geographic'
require_relative "model/agreement"
require_relative "model/fm"
require_relative "model/supply_teachers"

output_path = File.join(File.dirname(__FILE__), "gen")

metamodels = [Agreements, Parties, Geographic, SupplyTeacherOfferings]

diagram = Diagram.new(output_path, "metamodel")
diagram.describe *metamodels

doc = Document.new(output_path, "metamodel")
doc.document_metamodel *metamodels

models = [
    Agreements::Supply_Teacher_Agreements,
    Geographic::NUTS,
]

doc = Document.new(output_path, "supply_teachers")
doc.document Agreements::Supply_Teacher_Agreements

data = DataFile.new(output_path, "agreements", fmt: :json)
data.output *models
data = DataFile.new(output_path, "agreements", fmt: :yaml)
data.output *models
data = DataFile.new(output_path, "agreements", fmt: :jsonlines)
data.output *models, select: :agreement

# create a store for all parties in all models
parties= Parties.new :AllParties do
  party do
    org_name "CCS"
  end
end

# put test catalogues into test output
def test_data_file(name)
  File.join(File.dirname(__FILE__), "data", name)
end

sm_offers= load_managing_suppliers(test_data_file("teacher-management-test.csv"), parties)
sr_offers= load_recruitment_suppliers(test_data_file("teacher-recruitment-test.csv"), parties)

data= DataFile.new( output_path, "teacher-management-test-offers", fmt: :jsonlines)
data.output sm_offers, index: index_offering_for_elasticsearch

data= DataFile.new( output_path, "teacher-recruitment-test-offers", fmt: :jsonlines)
data.output sr_offers, index: index_offering_for_elasticsearch

# can now do something like:
#curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/offerings/offerings/_bulk --data-binary @teacher-management-test-offers.jsonlines

