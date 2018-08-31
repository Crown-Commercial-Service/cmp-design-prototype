require_relative "src/diagram"
require_relative "src/doc"
require_relative "src/data"
require_relative 'model/geographic'
require_relative "model/agreement"
require_relative "model/fm"
require_relative "model/supply_teachers"

path = File.join(File.dirname(__FILE__), '../', "gen")

metamodels = [Agreements, Parties, Geographic, FM_Offerings]
models = [
    Agreements::FM_Agreements,
    Agreements::ST_Agreements,
    Geographic::NUTS,
]

diagram = Diagram.new(path, "metamodel")
diagram.describe *metamodels

doc = Document.new(path, "metamodel")
doc.document_metamodel *metamodels

doc = Document.new(path, "data")
doc.document *models

data = DataFile.new(path, "data", fmt: :json)
data.output *models
data = DataFile.new(path, "data", fmt: :yaml)
data.output *models

# data= DataFile.new( path, "fm_agreements", fmt: :jsonlines)
# data.output Agreements::FM_Agreements

data = DataFile.new(path, "fm_catalogue", fmt: :jsonlines)
data.output FM_Offerings::FM_Catalogue

# data= DataFile.new( path, "st_agreements", fmt: :jsonlines)
# data.output Agreements::ST_Agreements
