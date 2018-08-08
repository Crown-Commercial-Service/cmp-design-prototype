class Element
  def initialize file
    @file = file
  end

  def finish
  end

  protected

  def pput(string)
    @file.print string
  end

end

class Category < Element

  def put cat
    pputs q! ##{cat}|
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
      graph = Graph.new(file)
      for model in models
        cat = Category.new(file)
        cat.put model
      end
    end
  end

  def docfile
    File.join(doc_path, "categories")
  end

  def doc_path
    File.join(self.path, "doc")
  end

end