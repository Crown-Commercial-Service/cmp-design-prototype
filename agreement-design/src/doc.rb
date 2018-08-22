require_relative 'transform'
include Transform

class Document < Output

  def document *models
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

  def document_metamodel *models
    FileUtils.mkpath doc_path
    File.open(self.docfile, "w") do |file|
      transform_metamodel(
          {
              before_model: lambda do |model:|
                file.print %Q!\# Data model: #{model}\n!
              end,
              before_group: lambda do |group|
                file.print %Q!\# #{cat.class}: #{cat.name}\n!
                if (cat.respond_to?(:description))
                  file.print %Q! #{cat.description}\n!
                end
              end,
              before_type: lambda do |type:, depth:|
                file.print "## #{type.typename}"
                if type.extends
                  file.print " extends #{type.extends}"
                end
                file.print "\n  #{type.description}\n\n"
                file.print "|attribute|type|multiplicity|description|\n"
                file.print "|---------|----|------------|-----------|\n"
              end,
              attribute: lambda do |id:, val:, type:, depth:|
                file.print "|#{val[:name]}|#{type_and_link(val)}|#{multiplicity(val)}|#{val[:description]}|\n"
              end,
              before_codes: lambda do |model:|
                file.print "# Codes\n"
              end,
              code: lambda do |model:, code:|
                file.print "## #{code[:id]} #{code[:title]}\n"
                file.print "#{code[:description]}\n"
                file.print "#{code[:uri]}\n"
              end
          }, *models)
    end
  end

  def docfile
    File.join(doc_path, "#{self.name}.md")
  end

  def doc_path
    File.join(self.path, "doc")
  end

  def multiplicity m
    m = m[:multiplicity]
    if m.end == -1
      if m.begin == 0
        return "*"
      else
        return "#{m.begin}..*"
      end
    end
    if m.end == m.begin
      return m.end.to_s
    end
    return m.to_s
  end

  private

  def type_and_link(val)
    if val[:links]
      return "#{val[:type]} -> #{val[:links]}"
    end
    val[:type]
  end

end