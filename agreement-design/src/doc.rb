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

def cond_call(depth, id, value, lam, lambdas)
  if lambdas[lam]
    return lambdas[lam].(depth, id, value)
  end
  return 0
end

# each lambda takes the depth, id, value
# Lambdas are:
#               :before_type_lambda,
#               :after_type_lambda,
#               :before_array_lambda,
#               :after_array_lambda,
#               :attribute_lambda
# which takes a type and returns an object (the id)
# depth is the number counting from zero, incremented with array elements and nested types.
# ID is a nested int of the type a for types and a.b for array types,
# and is the name of the attribute for attributes
# decl is the type or attribute or array

def transform_type depth, id, decl, lambdas

  if decl.class <= Array
    cond_call(depth, id, decl, :before_array_lambda, lambdas)
    j = 1
    for aa in decl
      transform_type(depth + 1, "#{id}.#{j}", aa, lambdas)
      j = j + 1
    end
    cond_call(depth, id, decl, :after_array_lambda, lambdas)
  elsif decl.class <= DataType
    cond_call(depth, id, decl, :before_type_lambda, lambdas)
    for ak in decl.attributes.keys
      av = decl.attributes[ak]
      transform_type(depth + 1, ak, av, lambdas)
    end
    cond_call(depth, id, decl, :after_type_lambda, lambdas)
  else
    cond_call(depth, id, decl, :attribute_lambda, lambdas)
  end
  self
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

class TypeDeclElement < Element

  def write indent, id, decl
    transform_type(indent, id, decl,
                   {
                  :before_type_lambda => lambda do |indent, id, decl|
                    pput %Q!####{'#' * indent} #{decl.name} #{decl.attributes[:id] || id} \n!
                  end,
                  :attribute_lambda => lambda do |indent, id, decl|
                    pput %Q!#{"  " * indent} - #{id} #{decl}\n!
                  end
              })
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
            TypeDeclElement.new(file).write(0, i, decl).finish
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