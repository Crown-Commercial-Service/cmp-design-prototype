module Transform

  class Output
    public

    attr_accessor :dir, :name, :ext

    def initialize dir, name, ext
      self.dir = dir
      self.name = name
      self.ext = ext
    end

    def filepath
      File.join(self.dir, "#{name}.#{ext}")
    end

    def file(&block)
      FileUtils.mkpath dir
      File.open(filepath, "w", &block)
    end
  end


  def before_model_lambda model: nil
    return [model: model]
  end

  def after_model_lambda model: nil, before: nil
    return [model: model, before: before]
  end

  def before_codes_lambda model: nil
    return [model: model]
  end

  def code_lambda model: nil, code: nil
    return [model: model, code: code]
  end

  def before_group_lambda name: nil, depth: 0
    return [name: name, depth: depth]
  end

  def after_group_lambda name: nil, before: nil, depth: 0
    return [name: name, before: before, depth: depth]
  end

  def before_type_lambda type: nil, depth: 0, index: 0, total: 1
    return [type: type, depth: depth, index: index, total: total]
  end

  def after_type_lambda type: nil, before: nil, depth: 0
    return [type: type, before: before, depth: depth]
  end

  def before_array_lambda name: nil, decl: nil, depth: 0, total: 1
    return [name: name, decl: decl, depth: depth, total: total]
  end

  def after_array_lambda index: 0, decl: nil, depth: 0, before: nil
    return [index: index, decl: decl, depth: depth, before: before]
  end

  def attribute_lambda id:, val:, depth: 0, type: nil, index:, total:
    return [id: id, val: val, depth: depth, type: type, index: index, total: total]
  end

  # @param models - the models to transform
  # @lambdas - set of function callbacks to transform

  def transform_datamodel lambdas, *models
    for model in models
      dom = cond_call(lambdas, :before_model, *before_model_lambda(model: model))
      for typename in model.contents.keys
        grp = cond_call(lambdas, :before_group, *before_group_lambda(name: typename))
        t = 0
        # there will be more than one of each type
        for type in model.contents[typename]
          transform_entry(lambdas, decl: type, name: typename, depth: 0, index: 0, total: 1)
          t = t + 1
        end
        grp = cond_call(lambdas, :after_group, *after_group_lambda(name: typename, before: grp))
      end
      cond_call(lambdas, :after_model, *after_model_lambda(model: model, before: dom))
    end
  end

  def transform_metamodel lambdas, *models
    for model in models
      dom = cond_call(lambdas, :before_model, *before_model_lambda(model: model))
      for type in model.types.values
        before = cond_call(lambdas, :before_type, *before_type_lambda(type: type, index: 0, total: 1))
        i = 0
        for ak in type.attributes.keys
          av = type.attributes[ak]
          cond_call(lambdas, :attribute, *attribute_lambda(id: ak, val: av, type: type, index: i, total: type.attributes.keys.length))
          i = i + 1
        end
        cond_call(lambdas, :after_type, *after_type_lambda(type: type, before: before))
      end
      cond_call(lambdas, :after_model, *after_model_lambda(model: model, before: dom))
      if model.respond_to? :codes
        cond_call(lambdas, :before_codes, *before_codes_lambda(model: model))
        for code in model.codes.values
          cond_call(lambdas, :code, *code_lambda(model: model, code: code))
        end
      end
    end
  end

  def cond_call(lambdas, lam, *args)
    if lambdas[lam]
      return lambdas[lam].(*args)
    end
    return 0
  end

  def transform_entry(lambdas, index:, name:, decl:, depth:, total:)

    if decl.class <= Array
      arrctx = cond_call(lambdas, :before_array, *before_array_lambda(name: name, decl: decl, depth: depth, total: decl.length))
      j = 0
      for aa in decl
        transform_entry(lambdas, index: j, decl: aa, name: name, depth: depth, total: decl.length)
        j = j + 1
      end
      cond_call(lambdas, :after_array, *after_array_lambda(index: index, decl: decl, depth: depth, before: arrctx))
    elsif decl.class <= DataType
      before = cond_call(lambdas, :before_type, *before_type_lambda(type: decl, depth: depth, index: index, total: total))
      i = 0
      for ak in decl.attributes.keys
        av = decl.attributes[ak]
        transform_entry(lambdas, name: ak, decl: av, depth: depth + 1, index: i, total: decl.attributes.keys.length)
        i = i + 1
      end
      cond_call(lambdas, :after_type, *after_type_lambda(type: decl, depth: depth, before: before))
    else
      cond_call(lambdas, :attribute, *attribute_lambda(id: name, val: decl, index: index, depth: depth, total: total))
    end
    self
  end

end