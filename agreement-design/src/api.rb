require_relative 'transform'
include Transform

# - create a file for each data type
# - create a file for each end point, referencing files
#   - link [https://swagger.io/docs/specification/using-ref/]
# - consier API endpoint config, e.g. AWS - [https://app.swaggerhub.com/help/integrations/amazon-api-gateway]
class API < Output

  # Not implemented yet
  #
  # we will spit out OpenAPI format files and stubs
  #
  # TODO : define API endpoint commands, similar to datatype commands, in domain

  # def openapi2 *models
  #   FileUtils.mkpath doc_path
  #   File.open(self.docfile, "w") do |file|
  #     transform_datamodel(
  #         {
  #             :before_type => lambda do |type:, depth: 0|
  #             end,
  #             :attribute => lambda do |id:, val:, depth: 0, type: nil|
  #             end
  #         }, *models)
  #   end
  # end
  #
  # def docfile
  #   File.join(doc_path, "#{self.name}.json")
  # end
  #
  # def doc_path
  #   File.join(self.path, "api")
  # end

end