require_relative "src/diagram"
require_relative "src/doc"
require_relative "src/data"
require_relative 'model/geographic'
require_relative "model/agreement"
require_relative "model/fm"
require_relative "model/supply_teachers"

path = File.join(File.dirname(__FILE__), "gen")

metamodels = [Agreements, Parties, Geographic, SupplyTeacherOfferings]
models = [
    Agreements::Supply_Teacher_Agreements,
    Geographic::NUTS,
]

diagram = Diagram.new(path, "metamodel")
diagram.describe *metamodels

doc = Document.new(path, "metamodel")
doc.document_metamodel *metamodels

doc = Document.new(path, "supply_teachers")
doc.document Agreements::Supply_Teacher_Agreements

data = DataFile.new(path, "data", fmt: :json)
data.output *models
data = DataFile.new(path, "data", fmt: :yaml)
data.output *models

# create a store for all parties in all models
parties= Parties.new :AllParties do
  party do
    org_name "CCS"
  end
end

def datafile(name)
  File.join(File.dirname(__FILE__), "data", name)
end

st_offers= load_managing_suppliers(datafile("teacher-management-test.csv"), parties)
puts models_to_data( st_offers).to_yaml

# data= DataFile.new( path, "fm_agreements", fmt: :jsonlines)
# data.output Agreements::FM_Agreements

# data = DataFile.new(path, "fm_catalogue", fmt: :jsonlines)
# data.output FM_Offerings::FM_Catalogue

# data= DataFile.new( path, "Supply_Teacher_Agreements", fmt: :jsonlines)
# data.output Agreements::Supply_Teacher_Agreements
