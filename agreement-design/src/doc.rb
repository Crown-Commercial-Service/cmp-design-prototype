class Element
  def initialize file
    @file = file
  end

  def finish
    self
  end

  protected

  def pput(string)
    @file.print string
    self
  end

end

class DomainElement < Element

  def write cat
    pput %Q!\# #{cat.class}: #{cat.name}\n!
  end

end

class GroupElement < Element

  def write grpname
    pput %Q!\## #{grpname}s\n!
  end

end

class DeclElement < Element

  def write indent, id, decl
    if decl.class <= Array
      j = 1
      for aa in decl
        DeclElement.new(@file).write(indent + 1, "#{id}.#{j}", aa).finish
        j = j + 1
      end
    elsif decl.class <= DataType
      pput %Q!####{'#' * indent} #{decl.name} #{decl.attributes[:id]||id}\n!
      for ak in decl.attributes.keys
        av = decl.attributes[ak]
        DeclElement.new(@file).write(indent + 1, ak, av).finish
      end
    else
      pput %Q!#{"  " * indent} - #{id} #{decl}\n!
    end
    self
  end

end

class Doc
  attr_accessor :path, :name

  def initialize path, name
    self.path = path
    self.name = name
  end

  def document *models
    FileUtils.mkpath doc_path
    File.open(self.docfile, "w") do |file|
      for model in models
        cat = DomainElement.new(file)
        cat.write model
        for typename in model.contents.keys
          grp = GroupElement.new(file)
          grp.write typename
          i = 1
          for decl in model.contents[typename]
            DeclElement.new(file).write(0, i, decl).finish
            i = i + 1
          end
          grp.finish
        end
        cat.finish
      end
    end
  end

  def docfile
    File.join(doc_path, "#{self.name}.md")
  end

  def doc_path
    File.join(self.path, "doc")
  end

end