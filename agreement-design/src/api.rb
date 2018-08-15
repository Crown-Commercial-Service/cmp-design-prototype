require_relative 'transform'
include Transform

class API < Output

  def openapi2 *models
    FileUtils.mkpath doc_path
    File.open(self.docfile, "w") do |file|
      transform_datamodel(
          {
              :before_type => lambda do |type:, depth: 0|
                file.print %Q!####{'#' * depth} #{type.name} #{type.attributes[:id] || ""} \n!
              end,
              :attribute => lambda do |id:, val:, depth: 0, type: nil|
                file.print %Q!#{"  " * depth} - #{id} #{val}\n!
              end
          }, *models)
    end
  end

  def docfile
    File.join(doc_path, "#{self.name}.json")
  end

  def doc_path
    File.join(self.path, "api")
  end

end